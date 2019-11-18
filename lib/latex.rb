require "erb"

def latex_from_options(options, output_dir_path)
  LaTeX.new(options[:template_path], output_dir_path, options[:verbose])
end

class LaTeX
  attr_reader :template
  attr_reader :output_dir_path, :path

  def initialize(template_path, output_dir_path, verbose)
    raise "template is missing: #{template_path}" unless File.exist?(template_path)

    @template = File.read(template_path)
    @output_dir_path = output_dir_path
    @verbose = verbose
    @path = File.join(output_dir_path, "result.tex")
  end

  def write!(invoice, target_path)
    result = render(invoice)

    File.open(@path, "w") do |file|
      file.puts result
    end

    print_content if @verbose
    make_pdf
    move_to target_path
  end

  def render(invoice)
    renderer = ERB.new(@template)
    invoice.render(renderer)
  end

  def print_content
    content = File.read(@path)

    puts "LaTeX content:"
    puts ""
    content.each_line.with_index do |line, i|
      padded_line_no = "%3.3s" % i.to_s
      puts "#{padded_line_no}:  #{line}"
    end
    puts ""
  end

  def make_pdf
    puts "Rendering with pdflatex ..." if @verbose
    cmd = %Q{#{LATEX_PATH} -output-directory "#{output_dir_path}" "#{path}" 2>&1 >/dev/null}
    puts cmd if @verbose
    system cmd
  end

  def move_to(target_path)
    puts %Q{Moving PDF to target path "#{target_path}" ...} if @verbose
    basename = File.basename(@path, ".tex")
    filename = basename + ".pdf"
    result_path = File.join(File.dirname(@path), filename)
    raise %Q{No PDF output at "#{result_path}"} unless File.exist?(result_path)
    FileUtils.move(result_path, target_path)
  end
end
