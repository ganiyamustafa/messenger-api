FactoryBot.define do
  factory :conversation do
    user_id { User.first.id }
    with_user_id { User.last.id }

    trait :user_id do |id|
      user_id { id }
    end

    trait :with_user_id do |id|
      with_user_id { id }
    end
  end
end
