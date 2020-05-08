require 'rails_helper'

RSpec.describe 'Todos API' do
  let(:user) { create(:user) }
  let(:headers) { { 'Authorization' => token_generator(user.id) } }

  # initialize test data
  let!(:todos) { create_list(:todo, 10, created_by: user.id) }
  let(:todo_id) { todos.first.id }

  # GET /todos
  describe 'GET /todos' do
    before { get '/todos', headers: headers }

    it 'returns todos' do
      # note `json` is a custom helper to parse JSON responses
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # GET
  describe 'GET /todos/:id' do
    before { get "/todos/#{todo_id}", headers: headers }

    context 'when the record exists' do
      it 'returns the todo' do
        # note `json` is a custom helper to parse JSON responses
        expect(json).not_to be_empty
        expect(json['id']).to eq(todo_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:todo_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Todo/)
      end
    end
  end

  # POST
  describe 'POST /todos' do
    # valid payload
    let(:valid_params) { { title: 'Learn Elixir', created_by: user.id.to_s } }

    context 'when the request is valid' do
      before { post '/todos', params: valid_params, headers: headers }

      it 'creates a todo' do
        expect(json['title']).to eq('Learn Elixir')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/todos', params: { created_by: user.id.to_s }, headers: headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: Title can't be blank/)
      end
    end
  end

  # PUT
  describe 'PUT /todos/:id' do
    let(:valid_params) { { title: 'Shopping' } }

    context 'when the record exists' do
      before { put "/todos/#{todo_id}", params: valid_params, headers: headers }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when the record does not exist' do
      let(:invalid_id) { '1000' }

      before { put "/todos/#{invalid_id}", params: valid_params, headers: headers }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body)
          .to match(/Couldn't find Todo/)
      end
    end
  end

  # DELETE
  describe 'DELETE /todos/:id' do
    before { delete "/todos/#{todo_id}", headers: headers }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
