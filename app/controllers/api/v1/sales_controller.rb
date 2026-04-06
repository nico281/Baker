class Api::V1::SalesController < ApplicationController
  before_action :set_customer
  before_action :set_sale, only: [ :show, :update, :destroy ]

  def index
    render json: @customer.sales
  end

  def show
    render json: @sale
  end

  def create
    sale = @customer.sales.new(sale_params)
    if sale.save
      render json: sale, status: :created
    else
      render json: { errors: sale.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @sale.update(sale_params)
      render json: @sale
    else
      render json: { errors: sale.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
   @sale.destroy
    render json: @sale, status: :no_content
  end

  private

    def set_customer
      @customer = Customer.find(params[:customer_id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Cliente no encontrado" }, status: :not_found
    end

    def set_sale
      @sale = @customer.sales.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Venta no encontrada" }, status: :not_found
    end

    def sale_params
      params.require(:sale).permit(:amount, :description)
    end
end
