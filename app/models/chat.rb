class Chat < ApplicationRecord
    belongs_to :chat_application
    has_many :messages
end
