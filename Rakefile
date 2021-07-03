#!/usr/bin/env ruby

require "date"
require "csv"
require_relative "lib/payment"

desc "Create reports from `file' for a the whole year of `year'"
task :year, [:file, :year] do |t, args|
  file, year = [args[:file], args[:year].to_i]
  payments = payments_from_csv(file)

  puts "Creating reports for #{year} from #{file}..."
  payments.filter { |p| p.is_year?(year) }.each do |payment|
    invoice_title = payment.date.strftime("%Y%m%d235512")
    filename = "#{invoice_title} FastSpring Rechnung #{payment.date}.pdf"
    puts %Q{- #{filename}: #{payment.amount}}
    system %Q{./report.rb --output "#{filename}" --invoice "#{invoice_title}" --date "#{payment.date}" --amount "#{payment.amount.sub("$", "\\$")}"}
  end
end

desc "Creates reports for the past year (#{Date.today.year - 1}) based on input from the file `data.tsv'"
task :default do
  # I believe we cannot use the usual Rake task prerequisite syntax
  # and supply default values for the expected task params
  Rake::Task[:year].invoke("data.tsv", Date.today.year - 1)
end
