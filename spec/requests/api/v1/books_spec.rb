require 'swagger_helper'

RSpec.describe 'books', type: :request do
  path "/api/v1/books" do
    post "Create a book" do
      tags "Books"
      consumes "application/json"
      parameter name: :books, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          author: { type: :string },
        },
        required: ["title", "author"],
      }
      response "201", "book created" do
        let(:book) { { title: 'Hello Title', author: 'Hello Author' } }
        run_test!
      end
      response "422", "invalid request" do
        let(:book) { { title: 'Hello Title' } }
        run_test!
      end
    end
  end
end
