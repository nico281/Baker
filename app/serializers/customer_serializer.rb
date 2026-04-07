class CustomerSerializer < BaseSerializer
  def as_json(*)
    total_sales = @object.sales.sum(:amount).to_f
    total_payments = @object.payments.sum(:amount).to_f
    base_fields.merge(
      name: @object.name,
      phone: @object.phone,
      notes: @object.notes,
      totalSales: total_sales,
      totalPayments: total_payments,
      balance: total_sales - total_payments
    )
  end
end
