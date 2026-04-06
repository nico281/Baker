require 'swagger_helper'

RSpec.describe 'Users Auth', type: :request do
  path '/users' do
    post('register user') do
      tags 'Auth'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string, format: :email },
              password: { type: :string, minLength: 6 }
            },
            required: %w[email password]
          }
        },
        required: %w[user]
      }

      response(201, 'user created') do
        let(:user) { { user: { email: 'test@example.com', password: 'password123' } } }

        run_test!
      end

      response(422, 'invalid params') do
        let(:user) { { user: { email: '', password: '123' } } }

        run_test!
      end
    end
  end

  path '/users/sign_in' do
    post('login user') do
      tags 'Auth'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string, format: :email },
              password: { type: :string }
            },
            required: %w[email password]
          }
        },
        required: %w[user]
      }

      response(200, 'login successful') do
        let(:registered_user) { User.create!(email: 'login@example.com', password: 'password123', password_confirmation: 'password123') }
        let(:user) { { user: { email: registered_user.email, password: 'password123' } } }

        run_test!
      end

      response(401, 'invalid credentials') do
        let(:user) { { user: { email: 'noone@example.com', password: 'wrongpassword' } } }

        run_test!
      end
    end
  end

  path '/users/sign_out' do
    delete('logout user') do
      tags 'Auth'
      produces 'application/json'
      security [ { bearer_auth: [] } ]

      response(200, 'logout successful') do
        let(:registered_user) { User.create!(email: 'logout@example.com', password: 'password123', password_confirmation: 'password123') }
        let(:Authorization) { "Bearer #{Warden::JWTAuth::UserEncoder.new.call(registered_user, :user, nil).first}" }

        run_test!
      end

      response(200, 'logout successful (no token)') do
        let(:Authorization) { nil }

        run_test!
      end
    end
  end
end
