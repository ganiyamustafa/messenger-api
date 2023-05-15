class ConversationsController < ApplicationController
  before_action -> { @user = AuthorizeApiRequest.new(request.headers).call[:user] }
  before_action :find_conversation, only: [:show, :get_chats]
  def index
    conversations, meta = Conversation.get_conversations(@user.id, params)
    render json: {data: ActiveModelSerializers::SerializableResource.new(conversations, each_serializer: ConversationSerializer)}, status: 200
  end

  def show
    render json: {data: ActiveModelSerializers::SerializableResource.new(@conversation, serializer: ConversationShowSerializer)}, status: 200
  end

  def get_chats
    chats, meta = Chat.get_all_chats_on_conversation(@conversation, params)
    render json: {data: ActiveModelSerializers::SerializableResource.new(chats, each_serializer: ChatSerializer)}, status: 200
  end

  private

  def find_conversation
    @conversation = Conversation.find(params[:id])
    if !@conversation.authorize_owner(@user.id)
      render json: {data: "Not Have Access"}, status: 403  
    end
  rescue StandardError
    render json: {data: "Not Found"}, status: 404
  end
end
