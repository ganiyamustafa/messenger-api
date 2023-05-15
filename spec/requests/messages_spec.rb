require 'rails_helper'

RSpec.describe 'Messages API', type: :request do
  before(:context) do
    @dimas = create(:user)
    @agus = create(:user)
    @dimas_headers = valid_headers(@dimas.id)

    @samid = create(:user)
    @samid_headers = valid_headers(@samid.id)
  end

  # let(:agus) { create(:user) }
  # let(:dimas) { create(:user) }
  # let(:dimas_headers) { valid_headers(dimas.id) }

  # let(:samid) { create(:user) }
  # let(:samid_headers) { valid_headers(samid.id) }

  # TODO: create conversation between Dimas and Agus, then set convo_id variable

  describe 'get list of messages' do
    before do 
      conversation = create(:conversation, user_id: @dimas.id)
      @convo_id = conversation.id
      create(:chat, conversation_id: @convo_id)
    end

    context 'when user have conversation with other user' do
      before { get "/conversations/#{@convo_id}/messages", params: {}, headers: @dimas_headers }

      it 'returns list all messages in conversation' do
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
                    message: { type: "string" },
                    sender: { 
                      type: "object",
                      properties: {
                        id: { type: "integer" },
                        name: { type: "string" }
                      },
                      required: ["id", 'name']
                    }
                  },
                  required: ["id", "message", "sender", "sent_at"]
                }
              }
            }
          }
          # data: [
          #   {
          #     id: Integer,
          #     message: String,
          #     sender: {
          #       id: Integer,
          #       name: String
          #     },
          #     sent_at: String
          #   }
          # ]
        )
      end
    end

    context 'when user try to access conversation not belong to him' do
      # TODO: create conversation and set convo_id variable
      before { get "/conversations/#{@convo_id}/messages", params: {}, headers: @samid_headers }

      it 'returns error 403' do
        expect(response).to have_http_status(403)
      end
    end

    context 'when user try to access invalid conversation' do
      # TODO: create conversation and set convo_id variable
      before { get "/conversations/-11/messages", params: {}, headers: @samid_headers }

      it 'returns error 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'send message' do
    let(:valid_attributes) do
      { message: 'Hi there!', user_id: @agus.id }
    end

    let(:invalid_attributes) do
      { message: '', user_id: @agus.id }
    end

    context 'when request attributes are valid' do
      before { post "/messages", params: valid_attributes, headers: @dimas_headers, as: :json}

      it 'returns status code 201 (created) and create conversation automatically' do
        expect_response(
          :created,
          {
            type: "object",
            properties: {
              data: {
                type: "object",
                properties: {
                  id: { type: "integer"},
                  message: { type: "string" },
                  sender: {
                    type: "object",
                    properties: {
                      id: { type: "integer"},
                      name: { type: "string" }
                    },
                    required: ["id", "name"]
                  },
                  sent_at: { stype: "string" },
                  conversation: {
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
                  },
                  required: ["id", "message", "sent_at", "conversation"]
                }
              },
              required: ["data"]
            }
          }
          # data: {
          #   id: Integer,
          #   message: String,
          #   sender: {
          #     id: Integer,
          #     name: String
          #   },
          #   sent_at: String,
          #   conversation: {
          #     id: Integer,
          #     with_user: {
          #       id: Integer,
          #       name: String,
          #       photo_url: String
          #     }
          #   }
          # }
        )
      end
    end

    context 'when create message into existing conversation' do
      before { post "/messages", params: valid_attributes, headers: @dimas_headers, as: :json}

      it 'returns status code 201 (created) and create conversation automatically' do
        expect_response(
          :created,
          {
            type: "object",
            properties: {
              data: {
                type: "object",
                properties: {
                  id: { type: "integer"},
                  message: { type: "string" },
                  sender: {
                    type: "object",
                    properties: {
                      id: { type: "integer"},
                      name: { type: "string" }
                    },
                    required: ["id", "name"]
                  },
                  sent_at: { stype: "string" },
                  conversation: {
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
                  },
                  required: ["id", "message", "sent_at", "conversation"]
                }
              },
              required: ["data"]
            }
          }
          # data: {
          #   id: Integer,
          #   message: String,
          #   sender: {
          #     id: Integer,
          #     name: String
          #   },
          #   sent_at: String,
          #   conversation: {
          #     id: convo_id,
          #     with_user: {
          #       id: Integer,
          #       name: String,
          #       photo_url: String
          #     }
          #   }
          # }
        )
      end
    end

    context 'when an invalid request' do
      before { post "/messages", params: invalid_attributes, headers: @dimas_headers, as: :json}

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end
    end
  end
end
