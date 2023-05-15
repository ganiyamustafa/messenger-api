class ChatSerializer < ActiveModel::Serializer
  attributes :id, :message, :sender, :sent_at

  def sender
    {
      id: object.sender.id,
      name: object.sender.name
    }
  end

  def sent_at
    object.created_at
  end
end
