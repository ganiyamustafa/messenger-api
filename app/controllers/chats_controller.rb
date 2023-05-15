class ChatsController < ApplicationController
  before_action -> { @user = AuthorizeApiRequest.new(request.headers).call[:user] }

  def create
    chat = Chat.create_message(message_params, @user.id)

    unless chat.valid?
      render json: { errors: chat.errors.full_messages }, status: 422
      return
    end

    render json: { data: ActiveModelSerializers::SerializableResource.new(chat, serializer: ChatDetailSerializer)}, status: 201
  end

  private

  def message_params
    params.permit(:user_id, :message)
  rescue ActionController::ParameterMissing => e
    {}
  end
end
