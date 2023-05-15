class CreateChats < ActiveRecord::Migration[6.1]
  def change
    create_table :chats do |t|
      t.string :message
      t.integer :sender_id, index: { unique: false }
      t.references :conversation, foreign_key: true, index: { unique: false }
      t.boolean :is_read, default: false
      t.timestamps
    end
    
    add_foreign_key :chats, :users, column: :sender_id
  end
end
