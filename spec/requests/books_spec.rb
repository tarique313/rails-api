require 'rails_helper'

describe 'Books API', type: :request do
  let(:first_author) {
    first_author = FactoryBot.create(:author, first_name: 'Test', last_name: 'Gazi', age: 35)
  }
  let(:second_author) {
    second_author = FactoryBot.create(:author, first_name: 'Test1', last_name: 'Gazi1', age: 39)
  }
  describe 'GET /books' do

    before do
      FactoryBot.create(:book, title: 'Test', author: first_author)
      FactoryBot.create(:book, title: 'The Time Machine', author: second_author)
    end
    it 'return all books' do
      get '/api/v1/books'
      expect(response).to have_http_status(:success)
      expect(response_body.size).to eq(2)
      expect(response_body).to eq(
                                             [
                                               {
                                                 'id' => 1,
                                                 'title' => 'Test',
                                                 'author_name' => 'Test Gazi',
                                                 'author_age' => 35
                                               },
                                               {
                                                 'id' => 2,
                                                 'title' => 'The Time Machine',
                                                 'author_name' => 'Test1 Gazi1',
                                                 'author_age' => 39
                                               }
                                             ]

                                           )
    end
    it 'returns a subset of books based on pagination of limit' do
      get '/api/v1/books', params: { limit: 1 }
      expect(response).to have_http_status(:success)
      expect(response_body.size).to eq(1)
      expect(response_body).to eq(
                                 [
                                   {
                                     'id' => 1,
                                     'title' => 'Test',
                                     'author_name' => 'Test Gazi',
                                     'author_age' => 35
                                   }
                                 ]
                               )

    end

    it 'returns subset of books based of limit and offset' do
    get '/api/v1/books', params: { limit: 1, offset: 1 }
    expect(response).to have_http_status(:success)
    expect(response_body.size).to eq(1)
    expect(response_body).to eq(
                               [
                                 {
                                   'id' => 2,
                                   'title' => 'The Time Machine',
                                   'author_name' => 'Test1 Gazi1',
                                   'author_age' => 39
                                 }
                               ]
                             )
    end
    it 'has a max limit of 100' do
      expect(Book).to receive(:limit).with(100).and_call_original
      get '/api/v1/books', params: { limit: 999 }
    end
  end

  describe 'POST /books' do
    it 'create a new book' do
      expect {
        post '/api/v1/books', params: {
          book: { title: 'Test'},
          author: { first_name: 'Test', last_name: 'Gazi', age: 35 }
        }
      }.to change { Book.count }.from(0).to(1)

      expect(response).to have_http_status(:created)
      expect(Author.count).to eq(1)
      expect(response_body).to eq(
                                 {
                                   'id' => 1,
                                   'title' => 'Test',
                                   'author_name' => 'Test Gazi',
                                   'author_age' => 35
                                 }
                               )
    end
  end

  describe 'DELETE /books/:id' do
    let!(:book) {
      FactoryBot.create(:book, title: 'Test', author: first_author)
    }
    it 'deletes a book' do
      expect {
        delete "/api/v1/books/#{book.id}"
        expect(response).to have_http_status(:no_content)
      }.to change { Book.count }.from(1).to(0)
    end
  end
end