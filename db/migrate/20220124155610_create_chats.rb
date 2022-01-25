class CreateChats < ActiveRecord::Migration[5.2]
  def change
    create_table :chats do |t|
      t.references :chat_application
      t.integer :application_chat_number, null: false, unique: true
      t.integer :messages_count, default: 0
      t.index [:chat_application_id,:application_chat_number], unique: true, name: "idx_application_chat"
      t.timestamps
    end
  end
end
