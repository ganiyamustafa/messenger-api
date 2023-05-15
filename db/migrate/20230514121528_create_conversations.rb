class CreateConversations < ActiveRecord::Migration[6.1]
  def change
    create_table :conversations do |t|
      t.references :user, foreign_key: true, index: { unique: false }
      t.integer :with_user_id, index: { unique: false }
      t.timestamps
    end

    add_foreign_key :conversations, :users, column: :with_user_id
  end
end
