class ChatDetailSerializer < ActiveModel::Serializer
  attributes :id, :message, :sender, :sent_at, :conversation

  def sender
    {
      id: object.sender.id,
      name: object.sender.name
    }
  end

  def conversation
    conversation = object.conversation
    {
      id: conversation.id,
      with_user: {
        id: conversation.with_user.id,
        name: conversation.with_user.name,
        photo_url: conversation.with_user.photo_url,
      }
    }
  end

  def sent_at
    object.created_at
  end
end
