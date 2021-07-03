# FastSpring Invoice Generator

## Installation

1. You need LaTeX installed on your system for PDF creation.
2. You need Ruby 2.5+, as I haven't tested with older versions.
3. Check out the project and open the folder:

        git clone git@github.com:DivineDominion/FastSpring-Beleg-Generator.git
        cd FastSpring-Beleg-Generator
4. Customize your LaTeX template in `template.tex.erb` or supply your own.

From that directory, you can now begin to generate reports!

## Basic Usage

To generate a single PDF:

    ./report.rb --invoice "2021/07-0100" --date 2021-07-03 --amount "\$200,45" --output "invoice.pdf"

![Sample Output](/assets/invoice-sample.png)

For a list of options, see the help:

    ./report.rb -h
    Usage: ./report.rb -i <invoice_no> -d <date> -a <amount> [options]

    Required parameters:
        -i, --invoice INVOICE            Invoice number or other identifier
        -d, --date DATE                  Date of the invoice
        -a, --amount AMOUNT              Price of the invoice

    Optional parameters:
        -o, --output [OUTPUT]            Output PDF file name
        -t, --template [TEMPLATE]        LaTeX ERb template path (default: template.tex.erb)
        -v, --verbose                    Output debug info
        -h, --help                       Prints this help

## Troubleshooting

It's possible you mess up the LaTeX template's syntax. Happens to me all the time.

To debug this, add the `-v` option to print the LaTeX processor's output. This will show syntax errors. Otherwise the output will be hidden and the script won't happen to do anything, stuck forever.

Always remember you can get out of the stuck state with <kbd>Ctrl</kbd>-<kbd>C</kbd>.

## Bulk Automation

The [Rakefile](/Rakefile) provides a couple of automation tasks. Use `rake -T` for documentation:

    rake default                     # Creates reports for the past year (2020) based on input from the file `data.tsv'
    rake quarter[file,year,quarter]  # Create reports from `file' for a quarter (1--4) of `year'
    rake year[file,year]             # Create reports from `file' for the whole year of `year'

The sample data in `data.tsv` demonstrates usage for any of these calls:

    $ rake 'month[data.tsv,2020,11]'
    $ rake 'quarter[data.tsv,2020,3]'
    $ rake 'year[data.tsv,2020]'

The default `rake` task will operate on the previous year, so for 2020-based sample data, it'll not produce any output once we hit 2022 :)

### How Data is Read

The sample data file contains these entries:

```
Status	Date	Type	Amount
Completed	07.12.2020 	Orders and Returns	$1337,00 USD
Completed	30.11.2020 	Orders and Returns	$123,45 USD
Completed	30.11.2020 	Payment	$-999,99 USD
Completed	21.11.2020 	Orders and Returns	$100,00 USD
Completed	16.11.2020 	Payment	$-222,22 USD
Completed	14.11.2020 	Orders and Returns	$200,00 USD
```

These are tab-separated values (TSV), i.e. copied straight from the FastSpring list of orders and payments.

**Only the "Payment" rows are used.**

The "Orders and Returns" columns usually add up in FastSpring, but to demonstrate that they are irrelevant for the generation of invoices, I've used totally different values. The script ignores these so you can simply copy and paste the table from the FastSpring backend without having to clean up anything.

### Where to Copy Your Data From

To learn how to get to the list of all payments, [see the FastSpring docs for detailed instructions](https://fastspring.com/docs/payment-details/); here's a short version:

1. Log into FastSpring's backend on https://app.fastspring.com/
2. Go to your Account Summary (top-right main menu)
3. Click the "Balance" dollar value to get to the list of "Account Transactions"

Then copy the data:

1. Copy the whole table starting from the "Status" column title in the top-left; browsers will transform the the table into tab-separated values
2. Paste into `data.tsv`

Compare with the initial dummy data. The CSV parser expects the column titles to be present.

Try the `rake` tasks on date ranges to see if it worked.

## License

Copyright (c) 2021 Christian Tietze. Distributed under the MIT License. See [LICENSE](/LICENSE) file.
