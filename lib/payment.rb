require "csv"

Payment = Struct.new(:date, :amount) do
  def is_year?(year)
    date.year.to_i == year.to_i
  end
end

def payment_from_options(options)
  missing_required = [:date, :amount] - options.keys
  raise OptionParser::MissingArgument.new(missing_required.join(", ")) unless missing_required.empty?
  return Payment.new(options[:date], options[:amount])
end

def payments_from_csv(data_path)
  raise %Q{No TSV data found at "#{data_path}"} unless File.exist?(data_path)

  csv_opts = {
    :headers => :first_row,
    :return_headers => false,
    :col_sep => "\t"
  }

  payments = []
  CSV.foreach(data_path, csv_opts) do |row|
    next unless row[0] == "Completed"
    next unless row[2] == "Payment"
    date = Date.parse(row[1])
    amount = row[3].sub("$-", "$")
    payments << Payment.new(date, amount)
  end
  payments
end
