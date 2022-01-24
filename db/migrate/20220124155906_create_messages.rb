class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.references :chat
      t.integer :chat_message_number, null: false
      t.index [:chat_id,:chat_message_number], unique: true, name: "idx_chat_message"
      t.timestamps
    end
  end
end
