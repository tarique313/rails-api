require 'rails_helper'

describe "Authentication", type: :request  do
  describe 'POST /authentication' do
    it 'authenticates the client' do
      post '/api/v1/authenticate', params: { username: 'BookSeller99', password: 'Password1'}

      expect(response).to have_http_status(:create)
      expect(response_body).to eq({
                                    'token' => '123'
                                  })
    end

    it 'returns error when username is missing' do
      post '/api/v1/authenticate', params: { password: 'Password1'}
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response_body).to eq({'error' => 'Param is missing: username'})
    end

    it 'returns error when password is missing' do
      post '/api/v1/authenticate', params: { username: 'BookSeller99'}
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response_body).to eq({'error' => 'Param is missing: password'})

    end
  end

end