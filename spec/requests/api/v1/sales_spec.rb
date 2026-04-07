require 'swagger_helper'

RSpec.describe 'api/v1/sales', type: :request do
  let(:auth_user) { User.create!(email: 'auth_test@example.com', password: 'password123', password_confirmation: 'password123') }
  let(:Authorization) { "Bearer #{Warden::JWTAuth::UserEncoder.new.call(auth_user, :user, nil).first}" }
  let(:customer_id) { Customer.create!(name: 'Venta Customer').id }

  path '/api/v1/customers/{customer_id}/sales' do
    parameter name: :customer_id, in: :path, type: :integer, description: 'Customer ID'

    get('list sales') do
      tags 'Sales'
      produces 'application/json'
      security [ { bearer_auth: [] } ]

      response(200, 'ok') do
        run_test!
      end
    end

    post('create sale') do
      tags 'Sales'
      consumes 'application/json'
      produces 'application/json'
      security [ { bearer_auth: [] } ]
      parameter name: :sale, in: :body, schema: {
        type: :object,
        properties: {
          amount: { type: :number },
          description: { type: :string }
        },
        required: %w[amount description]
      }

      response(201, 'created') do
        let(:sale) { { amount: 500, description: 'Pastel de chocolate' } }

        run_test!
      end

      response(422, 'invalid request') do
        let(:sale) { { amount: nil, description: '' } }

        run_test!
      end
    end
  end

  path '/api/v1/customers/{customer_id}/sales/{id}' do
    parameter name: :customer_id, in: :path, type: :integer, description: 'Customer ID'
    parameter name: :id, in: :path, type: :integer, description: 'Sale ID'

    let(:existing_customer) { Customer.create!(name: 'Venta Show Customer') }
    let(:existing_sale) { existing_customer.sales.create!(amount: 350, description: 'Pastel de vainilla') }

    get('show sale') do
      tags 'Sales'
      produces 'application/json'
      security [ { bearer_auth: [] } ]

      response(200, 'ok') do
        let(:customer_id) { existing_customer.id }
        let(:id) { existing_sale.id }

        run_test!
      end

      response(404, 'not found') do
        let(:customer_id) { existing_customer.id }
        let(:id) { 999_999 }

        run_test!
      end
    end

    patch('update sale') do
      tags 'Sales'
      consumes 'application/json'
      produces 'application/json'
      security [ { bearer_auth: [] } ]
      parameter name: :sale, in: :body, schema: {
        type: :object,
        properties: {
          amount: { type: :number },
          description: { type: :string }
        }
      }

      response(200, 'updated') do
        let(:customer_id) { existing_customer.id }
        let(:id) { existing_sale.id }
        let(:sale) { { amount: 400, description: 'Pastel actualizado' } }

        run_test!
      end
    end

    delete('delete sale') do
      tags 'Sales'
      produces 'application/json'
      security [ { bearer_auth: [] } ]

      response(204, 'deleted') do
        let(:customer_id) { existing_customer.id }
        let(:id) { existing_sale.id }

        run_test!
      end

      response(404, 'not found') do
        let(:customer_id) { existing_customer.id }
        let(:id) { 999_999 }

        run_test!
      end
    end
  end
end
