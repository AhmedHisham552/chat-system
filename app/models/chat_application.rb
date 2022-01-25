class ChatApplication < ApplicationRecord
    has_many :chats

    def update_chats_count!
        self.update_column(:chats_count,self.chats.length)
    end
end
