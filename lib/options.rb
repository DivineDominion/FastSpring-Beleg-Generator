require "optparse"
require "optparse/date"

def parse_options
  args = {
    :output_filename => "output.pdf",
    :template_path => DEFAULT_TEMPLATE_PATH,
    :verbose => false
  }
  parser = OptionParser.new do |opts|
    opts.banner = "Usage: #{$0} -i <invoice_no> -d <date> -a <amount> [options]"

    opts.separator ""
    opts.separator "Required parameters:"

    opts.on("-i", "--invoice INVOICE", :REQUIRED, String, "Invoice number or other identifier") do |inv|
      args[:invoice] = inv
    end

    opts.on("-d", "--date DATE", :REQUIRED, Date, "Date of the invoice") do |date|
      args[:date] = date
    end

    opts.on("-a", "--amount AMOUNT", :REQUIRED, String, "Price of the invoice") do |amount|
      args[:amount] = amount
    end

    opts.separator ""
    opts.separator "Optional parameters:"

    opts.on("-o", "--output [OUTPUT]", String, "Output PDF file name") do |name|
      args[:output_filename] = name
    end

    opts.on("-t", "--template [TEMPLATE]", String, "LaTeX ERb template path (default: template.tex.erb)") do |path|
      args[:template_path] = path
    end

    opts.on("-v", "--verbose", "Output debug info") do
      args[:verbose] = true
    end

    opts.on_tail("-h", "--help", "Prints this help") do
      puts opts
      exit
    end
  end
  return [parser, args]
end
