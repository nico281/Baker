class Api::V1::SalesController < ApplicationController
  before_action :set_customer
  before_action :set_sale, only: [ :show, :update, :destroy ]

  def index
    render json: @customer.sales
  end

  def show
    render json: @sale
  end
end
