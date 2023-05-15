class ConversationShowSerializer < ActiveModel::Serializer
  attributes :id, :with_user

  def with_user
    {
      id: object.with_user.id,
      name: object.with_user.name,
      photo_url: object.with_user.photo_url
    }
  end
end
