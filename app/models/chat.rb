class Chat < ApplicationRecord
  belongs_to :conversation
  belongs_to :sender, class_name: 'User'

  validates :message, presence: { allow_blank: false }

  def self.get_all_chats_on_conversation(conversation, query)
    limit = (query[:limit] || 10)
    offset = (((query[:page] || 1) - 1) * limit)

    chats = conversation.chats.limit(limit).offset(offset)
    chat_count = conversation.chats.count('id')

    meta = {
      page: query[:page],
      total: chat_count,
      limit: limit,
      last_page: (chat_count / limit.to_f).ceil
    }

    return chats, meta
  end

  def self.create_message(payload, sender_id)
    conversation = Conversation.find_by("(user_id = :sender_id and with_user_id = :with_user_id) or ((user_id = :with_user_id and with_user_id = :sender_id))", 
      sender_id: sender_id, with_user_id: payload[:user_id])

    unless conversation.present?
      conversation = Conversation.create!(user_id: sender_id, with_user_id: payload[:user_id])
    end

    message_data = payload.except(:user_id).merge(sender_id: sender_id, conversation_id: conversation.id)

    create(message_data)
  end
end
