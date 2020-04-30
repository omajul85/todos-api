require 'rails_helper'

RSpec.describe AuthorizeApiRequest do
  let(:user) { create(:user) }

  let(:header) { { 'Authorization' => token_generator(user.id) } }

  # Valid request subject
  subject(:request_object) { described_class.new(valid_headers) }

  # Invalid request subject
  subject(:invalid_request_object) { described_class.new(invalid_headers) }

  # Test Suite for AuthorizeApiRequest#call
  # This is our entry point into the service class
  describe '#call' do
    # returns user object when request is valid
    context 'when valid request' do
      it 'returns user object' do
        result = request_object.call

        expect(result[:user]).to eq(user)
      end
    end

    # returns error message when request is invalid
    context 'when invalid request' do
      context 'when missing token' do
        it 'raises a MissingToken error' do
          expect { invalid_request_object.call }
            .to raise_error(ExceptionHandler::MissingToken, /Missing token/)
        end
      end

      context 'when invalid token' do
        subject(:invalid_request_object) { described_class.new({ 'Authorization' => token_generator(5) }) }

        it 'raises a InvalidToken error' do
          expect { invalid_request_object.call }
            .to raise_error(ExceptionHandler::InvalidToken, /Invalid token/)
        end
      end

      context 'when token is expired' do
        let(:header) { { 'Authorization' => token_generator(user.id, expired: true) } }
        subject(:request_object) { described_class.new(header) }

        it 'raises a ExpiredSignature error' do
          expect { request_object.call }
            .to raise_error(ExceptionHandler::InvalidToken, /Signature has expired/)
        end
      end

      context 'when token is tampered' do
        let(:header) { { 'Authorization' => 'loremipsum' } }
        subject(:invalid_request_object) { described_class.new(header) }

        it 'handles JWT::DecodeError' do
          expect { invalid_request_object.call }
            .to raise_error(ExceptionHandler::InvalidToken, /Not enough or too many segments/)
        end
      end
    end
  end
end
