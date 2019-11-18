#!/usr/bin/env ruby

require "csv"
require_relative "lib/payment"

task :default do
  payments = payments_from_csv("data.tsv")

  payments.filter { |p| p.is_year?(2019) }.each do |payment|
    invoice_title = payment.date.strftime("%Y%m%d235512")
    filename = "#{invoice_title} FastSpring Rechnung #{payment.date}.pdf"
    puts %Q{#{filename}: #{payment.amount}}
    system %Q{./report.rb --output "#{filename}" --invoice "#{invoice_title}" --date "#{payment.date}" --amount "#{payment.amount.sub("$", "\\$")}"}
  end
end
