# app/serializers/base_serializer.rb
class BaseSerializer
  def initialize(object)
    @object = object
  end

  private

  def base_fields
    {
      id: @object.id,
      createdAt: @object.created_at,
      updatedAt: @object.updated_at
    }
  end
end
