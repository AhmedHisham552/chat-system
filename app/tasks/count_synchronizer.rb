module CountSynchronizer
    def self.sync_messages_count
        Chat.includes(:messages).find_in_batches do |chats|
            chats.each do |chat|
                chat.update_messages_count!
            end

        end
    end

    def self.sync_chats_count
        ChatApplication.includes(:chats).find_in_batches do |apps|
            apps.each do |app|
                app.update_chats_count!
            end
        end
    end
end
