FactoryBot.define do
    factory :message do
        body { 'This is a test body' }
        chat
        sequence :chat_message_number
    end
end