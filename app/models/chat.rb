class Chat < ApplicationRecord
    belongs_to :chat_application
    has_many :messages, dependent: :destroy
    
    def update_messages_count!
        self.update_column(:messages_count,self.messages.length)
    end

    def redis_cleanup
        REDIS.del("#{self.chat_application.token}:#{self.application_chat_number}")
    end
end
