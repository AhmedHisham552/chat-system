class Chat < ApplicationRecord
    belongs_to :chat_application
    has_many :messages, dependent: :destroy

    def update_messages_count!
        self.update_column(:messages_count,self.messages.length)
    end

    def redis_cleanup
        REDIS.del("#{self.chat_application.token}:#{self.application_chat_number}")
    end

    def search_query_generator(query)
        {
            _source: [:chat_message_number,:body, :created_at],
            query: {
                bool: {
                    must: [
                    {
                        match: {
                            chat_id: self.id
                        }
                    },
                    {
                        match: {
                            body: query
                        }
                    }
                    ]
                }
            }
        }
    end
end
