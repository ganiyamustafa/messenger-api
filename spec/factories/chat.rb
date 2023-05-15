FactoryBot.define do
  factory :chat do
    sender_id { User.first.id }
    message { Faker::Name.name }
    conversation_id { Conversation.last.id }

    trait :conversation_id do |id|
      conversation_id { id }
    end

  end
end