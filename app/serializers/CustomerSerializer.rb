class CustomerSerializer
  def initialize(customer)
    @customer = customer
  end
  def as_json
      total_sales = @customer.sales.sum(&:amount).to_f
      total_payments = @customer.payments.sum(&:amount).to_f
    {
      id: @customer.id,
      name: @customer.name,
      phone: @customer.phone,
      notes: @customer.notes,
      totalSales: total_sales,
      totalPayments: total_payments,
      balance: @customer.sales.sum(&:amount).to_f - @customer.payments.sum(&:amount).to_f
    }
  end
end
