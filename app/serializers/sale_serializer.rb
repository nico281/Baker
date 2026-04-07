class SaleSerializer < BaseSerializer
  def as_json(*)
    base_fields.merge(
      customerId: @object.customer_id,
      description: @object.description,
      amount: @object.amount.to_f,
      date: @object.date
    )
  end
end
