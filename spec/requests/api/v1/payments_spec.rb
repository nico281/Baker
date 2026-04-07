require 'swagger_helper'

RSpec.describe 'api/v1/payments', type: :request do
  let(:auth_user) { User.create!(email: 'auth_test@example.com', password: 'password123', password_confirmation: 'password123') }
  let(:Authorization) { "Bearer #{Warden::JWTAuth::UserEncoder.new.call(auth_user, :user, nil).first}" }
  let(:customer_id) { Customer.create!(name: 'Pago Customer').id }

  path '/api/v1/customers/{customer_id}/payments' do
    parameter name: :customer_id, in: :path, type: :integer, description: 'Customer ID'

    get('list payments') do
      tags 'Payments'
      produces 'application/json'
      security [ { bearer_auth: [] } ]

      response(200, 'ok') do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   customerId: { type: :integer },
                   amount: { type: :number },
                   date: { type: :string, format: 'date', nullable: true },
                   notes: { type: :string, nullable: true },
                   createdAt: { type: :string, format: 'date-time' },
                   updatedAt: { type: :string, format: 'date-time' }
                 },
                 required: %w[id customerId amount]
               }

        run_test!
      end
    end

    post('create payment') do
      tags 'Payments'
      consumes 'application/json'
      produces 'application/json'
      security [ { bearer_auth: [] } ]
      parameter name: :payment, in: :body, schema: {
        type: :object,
        properties: {
          amount: { type: :number },
          notes: { type: :string }
        },
        required: %w[amount]
      }

      response(201, 'created') do
        let(:payment) { { amount: 150.50, notes: 'Primer pago' } }

        run_test!
      end

      response(422, 'invalid request') do
        let(:payment) { { amount: nil } }

        run_test!
      end
    end
  end

  path '/api/v1/customers/{customer_id}/payments/{id}' do
    parameter name: :customer_id, in: :path, type: :integer, description: 'Customer ID'
    parameter name: :id, in: :path, type: :integer, description: 'Payment ID'

    let(:existing_customer) { Customer.create!(name: 'Pago Show Customer') }
    let(:existing_payment) { existing_customer.payments.create!(amount: 200) }

    get('show payment') do
      tags 'Payments'
      produces 'application/json'
      security [ { bearer_auth: [] } ]

      response(200, 'ok') do
        let(:customer_id) { existing_customer.id }
        let(:id) { existing_payment.id }

        run_test!
      end

      response(404, 'not found') do
        let(:customer_id) { existing_customer.id }
        let(:id) { 999_999 }

        run_test!
      end
    end

    patch('update payment') do
      tags 'Payments'
      consumes 'application/json'
      produces 'application/json'
      security [ { bearer_auth: [] } ]
      parameter name: :payment, in: :body, schema: {
        type: :object,
        properties: {
          amount: { type: :number },
          notes: { type: :string }
        }
      }

      response(200, 'updated') do
        let(:customer_id) { existing_customer.id }
        let(:id) { existing_payment.id }
        let(:payment) { { amount: 300, notes: 'Pago actualizado' } }

        run_test!
      end
    end

    delete('delete payment') do
      tags 'Payments'
      produces 'application/json'
      security [ { bearer_auth: [] } ]

      response(204, 'deleted') do
        let(:customer_id) { existing_customer.id }
        let(:id) { existing_payment.id }

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
