#!/usr/bin/env ruby

require "tmpdir"
require_relative "lib/options"
require_relative "lib/payment"
require_relative "lib/invoice"
require_relative "lib/latex"

LATEX_PATH = %x{which pdflatex}.strip
if LATEX_PATH.empty?
  puts "pdflatex cannot be found. Is LaTeX installed?"
  exit 1
end

CURRENT_DIR = File.expand_path(File.dirname(__FILE__))
DEFAULT_TEMPLATE_PATH = File.join(CURRENT_DIR, "template.tex.erb")

parser, args = parse_options()

begin
  parser.parse!
  payment = payment_from_options(args)
  invoice = Invoice.new(payment.date, args[:invoice], payment.amount)
rescue OptionParser::MissingArgument,
       OptionParser::InvalidArgument => error
  puts error
  puts ""
  puts parser.help
  exit 1
end

Dir.mktmpdir do |tmp_dir_path|
  puts %Q{Writing result to "#{tmp_dir_path}"} if args[:verbose]
  output_path = File.expand_path(args[:output_filename])
  latex = latex_from_options(args, tmp_dir_path)
  latex.write!(invoice, output_path)
end
