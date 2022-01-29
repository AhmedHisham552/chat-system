FactoryBot.define do
    factory :chat_application do
        name { 'Application' }
        token { ::SecureRandom.uuid }
    end
end