class Invoice
  attr_accessor :date, :invoice_number, :amount

  def initialize(date, invoice_number, amount)
    @date = date
    @invoice_number = invoice_number
    @amount = amount.sub("$", "\\$")
  end

  def render(renderer)
    renderer.result(binding)
  end
end
