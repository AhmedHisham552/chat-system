class CreateChatApplications < ActiveRecord::Migration[5.2]
  def change
    create_table :chat_applications do |t|
      t.string :token, null: false
      t.string :name, null: false 
      t.integer :chats_count, default: 0
      t.index :token, unique: true
      t.timestamps
    end
  end
end
