class CustomerSerializer < BaseSerializer
  def as_json(*)
      total_sales = @customer.sales.sum(&:amount).to_f
      total_payments = @customer.payments.sum(&:amount).to_f
    base_fields.merge(
      id: @customer.id,
      name: @customer.name,
      phone: @customer.phone,
      notes: @customer.notes,
      totalSales: total_sales,
      totalPayments: total_payments,
      balance: @customer.sales.sum(&:amount).to_f - @customer.payments.sum(&:amount).to_f,
      createdAt: @customer.created_at,
      updatedAt: @customer.updated_at
    )
  end
end
