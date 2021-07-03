#!/usr/bin/env ruby

require "date"
require "csv"
require_relative "lib/payment"

MONTHS_PER_QUARTER = {
  1 => [1, 2, 3],
  2 => [4, 5, 6],
  3 => [7, 8, 9],
  4 => [10, 11, 12]
}

def generate_report(payment)
  date = payment.date
  amount = payment.amount.sub("$", "\\$")  # Escape $ for LaTeX
  # Date-based invoices are easiest to generate; can be customized
  invoice_no = payment.date.strftime("%Y%m%d235512")
  filename = "#{invoice_no} FastSpring Rechnung #{date}.pdf"

  puts %Q{- #{filename}: #{payment.amount}}
  system %Q{./report.rb --output "#{filename}" --invoice "#{invoice_no}" --date "#{date}" --amount "#{amount}"}
end

desc "Create reports from `file' for `month` of `year'"
task :month, [:file, :year, :month] do |t, args|
  file, year, month = [args[:file], args[:year].to_i, args[:month].to_i]
  payments = payments_from_csv(file)

  puts "Creating report for #{year}-#{month} from #{file}..."
  payments
    .filter { |p| p.is_year?(year) && p.is_month?(month) }
    .each { |p| generate_report(p) }
end

desc "Create reports from `file' for a quarter (1--4) of `year'"
task :quarter, [:file, :year, :quarter] do |t, args|
  file, year, quarter = [args[:file], args[:year].to_i, args[:quarter].to_i]
  payments = payments_from_csv(file)
  valid_months = MONTHS_PER_QUARTER[quarter]

  puts "Creating reports for Q#{quarter}/#{year} from #{file}..."
  payments
    .filter { |p| p.is_year?(year) &&
              valid_months.any? { |m| p.is_month?(m) } }
    .each { |p| generate_report(p) }
end

desc "Create reports from `file' for the whole year of `year'"
task :year, [:file, :year] do |t, args|
  file, year = [args[:file], args[:year].to_i]
  payments = payments_from_csv(file)

  puts "Creating reports for #{year} from #{file}..."
  payments
    .filter { |p| p.is_year?(year) }
    .each { |p| generate_report(p) }
end

desc "Creates reports for the past year (#{Date.today.year - 1}) based on input from the file `data.tsv'"
task :default do
  # I believe we cannot use the usual Rake task prerequisite syntax
  # and supply default values for the expected task params
  Rake::Task[:year].invoke("data.tsv", Date.today.year - 1)
end
