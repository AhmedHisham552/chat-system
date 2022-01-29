FactoryBot.define do
    factory :chat do
        name { 'Chat' }
        chat_application
        sequence :application_chat_number
    end
end