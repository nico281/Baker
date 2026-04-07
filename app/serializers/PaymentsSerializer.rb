class PaymentsSerializer < BaseSerializer
  def as_json(*)
    base_fields.merge(
      customerId: @object.customer_id,
      amount: @object.amount.to_f,
      date: @object.date,
      notes: @object.notes
    )
  end
end
