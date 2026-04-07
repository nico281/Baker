require 'swagger_helper'

RSpec.describe 'api/v1/customers', type: :request do
  let(:auth_user) { User.create!(email: 'auth_test@example.com', password: 'password123', password_confirmation: 'password123') }
  let(:Authorization) { "Bearer #{Warden::JWTAuth::UserEncoder.new.call(auth_user, :user, nil).first}" }

  path '/api/v1/customers' do
    get('list customers') do
      tags 'Customers'
      produces 'application/json'
      security [ { bearer_auth: [] } ]

      response(200, 'ok') do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   name: { type: :string },
                   phone: { type: :string, nullable: true },
                   notes: { type: :string, nullable: true },
                   totalSales: { type: :number },
                   totalPayments: { type: :number },
                   balance: { type: :number }
                 },
                 required: %w[id name totalSales totalPayments balance]
               }

        before do
          c = Customer.create!(name: 'Con ventas')
          c.sales.create!(amount: 100, description: 'Pastel')
        end

        run_test!
      end
    end

    post('create customer') do
      tags 'Customers'
      consumes 'application/json'
      produces 'application/json'
      security [ { bearer_auth: [] } ]
      parameter name: :customer, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          phone: { type: :string },
          notes: { type: :string }
        },
        required: %w[name]
      }

      response(201, 'created') do
        let(:customer) { { name: 'Juan Perez', phone: '1234567890', notes: 'Cliente frecuente' } }

        run_test!
      end

      response(422, 'invalid request') do
        let(:customer) { { name: '' } }

        run_test!
      end
    end
  end

  path '/api/v1/customers/{id}' do
    parameter name: :id, in: :path, type: :integer, description: 'Customer ID'

    get('show customer') do
      tags 'Customers'
      produces 'application/json'
      security [ { bearer_auth: [] } ]

      response(200, 'customer with zero balance') do
        let(:id) { Customer.create!(name: 'Sin movimientos').id }

        schema type: :object,
               properties: {
                 id: { type: :integer },
                 name: { type: :string },
                 phone: { type: :string, nullable: true },
                 notes: { type: :string, nullable: true },
                 totalSales: { type: :number },
                 totalPayments: { type: :number },
                 balance: { type: :number }
               },
               required: %w[id name totalSales totalPayments balance]

        run_test!
      end

      response(200, 'customer with positive balance (debtor)') do
        let(:c) { Customer.create!(name: 'Deudor') }
        let(:id) do
          c.sales.create!(amount: 500, description: 'Pastel grande')
          c.payments.create!(amount: 200)
          c.id
        end

        run_test!
      end

      response(200, 'customer with negative balance (credit)') do
        let(:c) { Customer.create!(name: 'Con credito') }
        let(:id) do
          c.sales.create!(amount: 100, description: 'Galletas')
          c.payments.create!(amount: 300)
          c.id
        end

        run_test!
      end

      response(200, 'customer fully paid') do
        let(:c) { Customer.create!(name: 'Al dia') }
        let(:id) do
          c.sales.create!(amount: 250, description: 'Pastel mediano')
          c.payments.create!(amount: 250)
          c.id
        end

        run_test!
      end

      response(404, 'not found') do
        let(:id) { 999_999 }

        run_test!
      end
    end

    patch('update customer') do
      tags 'Customers'
      consumes 'application/json'
      produces 'application/json'
      security [ { bearer_auth: [] } ]
      parameter name: :customer, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          phone: { type: :string },
          notes: { type: :string }
        }
      }

      response(200, 'updated') do
        let(:id) { Customer.create!(name: 'Carlos Garcia').id }
        let(:customer) { { name: 'Carlos G. Actualizado' } }

        run_test!
      end
    end

    delete('delete customer') do
      tags 'Customers'
      produces 'application/json'
      security [ { bearer_auth: [] } ]

      response(204, 'deleted') do
        let(:id) { Customer.create!(name: 'A borrar').id }

        run_test!
      end

      response(404, 'not found') do
        let(:id) { 999_999 }

        run_test!
      end
    end
  end
end
