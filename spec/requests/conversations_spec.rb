require 'rails_helper'
require 'json_matchers/rspec'

RSpec.describe 'Conversations API', type: :request do
  before(:context) do
    @dimas = create(:user)
    @dimas_headers = valid_headers(@dimas.id)

    @samid = create(:user)
    @samid_headers = valid_headers(@samid.id)
  end
  # let(:dimas) { create(:user) }
  # let(:dimas_headers) { valid_headers(dimas.id) }

  # let(:samid) { create(:user) }
  # let(:samid_headers) { valid_headers(samid.id) }

  describe 'GET /conversations' do
    context 'when user have no conversation' do
      # make HTTP get request before each example
      before { get '/conversations', params: {}, headers: @dimas_headers }

      it 'returns empty data with 200 code' do
        expect_response(
          :ok,
          {
            type: "object",
            properties: {
              data: {
                type: "array"
              }
            },
            required: ["data"]
          }
        )
      end
    end

    context 'when user have conversations' do
      # TODOS: Populate database with conversation of current user
      before do 
        5.times do 
          conversation = create(:conversation)
          create(:chat, conversation_id: conversation.id)
        end
      end
      before { 
        get '/conversations', params: {}, headers: @dimas_headers 
      }

      it 'returns list conversations of current user' do
        # Note `response_data` is a custom helper
        # to get data from parsed JSON responses in spec/support/request_spec_helper.rb

        expect(response_data).not_to be_empty
        expect(response_data.size).to eq(5)
      end

      it 'returns status code 200 with correct response' do
        expect_response(
          :ok,
          {
            type: "object",
            properties: {
              data: {
                type: "array",
                items: {
                  type: "object",
                  properties: {
                    id: { type: "integer" },
                    with_user: {
                      type: "object",
                      properties: {
                        id: { type: "integer" },
                        name: { type: "string" },
                        photo_url: { type: "string" }
                      },
                      required: ["id", "name", "photo_url"]
                    },
                    last_message: { 
                      type: "object",
                      properties: {
                        id: { type: "integer" },
                        sender: {
                          type: "object",
                          properties: {
                            id: { type: "integer" },
                            name: { type: "string" },
                          }
                        },
                        sent_at: { type: "string" }
                      }
                    },
                    unread_count: { type: "integer" }
                  },
                  required: ["id", "with_user", "last_message", "unread_count"]
                }
              }
            },
            required: ["data"]
          })
      end
    end
  end

  describe 'GET /conversations/:id' do
    before do 
      conversation = create(:conversation)
      @convo_id = conversation.id
      create(:chat, conversation_id: @convo_id)
    end
    context 'when the record exists' do
      # TODO: create conversation of dimas
      before { get "/conversations/#{@convo_id}", params: {}, headers: @dimas_headers }

      it 'returns conversation detail' do
        expect_response(
          :ok,
          {
            type: "object",
            properties: {
              data: {
                type: "object",
                properties: {
                  id: { type: "integer" },
                  with_user: {
                    type: "object",
                    properties: {
                      id: { type: "integer" },
                      name: { type: "string" },
                      photo_url: { type: "string" }
                    },
                    required: ["id", "name", "photo_url"]
                  }
                },
                required: ["id", "with_user"]
              }
            },
            required: ["data"]
          }
        )
      end
    end

    context 'when current user access other user conversation' do
      before { get "/conversations/#{@convo_id}", params: {}, headers: @samid_headers }

      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
    end

    context 'when the record does not exist' do
      before { get "/conversations/-11", params: {}, headers: @dimas_headers }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end
end