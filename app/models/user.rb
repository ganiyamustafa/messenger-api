class User < ApplicationRecord
  has_many :conversations
  has_many :with_user_conversations, class_name: "Conversation", foreign_key: :with_user_id
  has_many :chats, foreign_key: :sender_id
  # encrypt password
  has_secure_password
end
