class Conversation < ApplicationRecord
  has_many :chats
  belongs_to :user
  belongs_to :with_user, class_name: "User"

  def self.get_conversations(user_id, query)
    limit = (query[:limit] || 10)
    offset = (((query[:page] || 1) - 1) * limit)
    conversations = where(user_id: user_id).left_joins(:chats)
      .select("conversations.*, count(CASE WHEN NOT chats.is_read THEN chats.is_read END) as unread_count")
      .group("conversations.id, chats.id").limit(limit).offset(offset)
    conversation_count = where(user_id: user_id).count('id')
    
    meta = {
      page: query[:page],
      total: conversation_count,
      limit: limit,
      last_page: (conversation_count / limit.to_f).ceil
    }

    return conversations, meta
  end

  def authorize_owner(owner_id)
    if user_id != owner_id
      return false
    end

    return true
  end
end
