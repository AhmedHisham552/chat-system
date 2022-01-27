class Chat < ApplicationRecord
    belongs_to :chat_application
    has_many :messages, dependent: :destroy

    def update_messages_count!
        self.update_column(:messages_count,self.messages.length)
    end
end
