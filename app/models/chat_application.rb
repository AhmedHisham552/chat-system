class ChatApplication < ApplicationRecord
    has_many :chats, dependent: :destroy

    def update_chats_count!
        self.update_column(:chats_count,self.chats.length)
    end

    def redis_cleanup
        REDIS.del(REDIS.keys("#{self.token}*"))
    end
end
