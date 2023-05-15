class ConversationSerializer < ActiveModel::Serializer
  attributes :id, :with_user, :last_message, :unread_count

  def with_user
    {
      id: object.with_user.id,
      name: object.with_user.name,
      photo_url: object.with_user.photo_url
    }
  end

  def last_message
    last_message = object.chats.last

    if last_message
      {
        id: last_message.id,
        sender: {
          id: last_message.sender.id,
          name: last_message.sender.name
        },
        sent_at: last_message.created_at
      }
    end
  end

  def unread_count
    object.unread_count
  end
end
