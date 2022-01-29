require "rails_helper"
RSpec.describe MessagesController, type: :controller do

    describe "GET index" do
        context "no applications and chats" do
            it "should return no messages" do
                expect { get :index, params:{token: ::SecureRandom.uuid,chatNumber: 1}}.to raise_error(ActiveRecord::RecordNotFound)
            end
        end

        context "applications and chats exist" do
            let!(:chat_application) { FactoryBot.create(:chat_application) }
            let!(:chat) { FactoryBot.create(:chat, chat_application: chat_application) }
            context "no messages exist" do
                it "should return no messages" do
                    get :index,params:{token: chat_application.token,chatNumber: chat.application_chat_number}
                    expect(response.status).to eq 200
                    expect(response.body).to eq [].to_json
                end
            end

            context "one message exists" do
                let!(:message){FactoryBot.create(:message,chat: chat)}
                it "should return the message" do
                    get :index,params:{token: chat_application.token,chatNumber: chat.application_chat_number}
                    expect(response.status).to eq 200
                    expect(response.body).to eq [{chat_message_number: message.chat_message_number,body: message.body,created_at: message.created_at,updated_at: message.updated_at,}].to_json
                end
            end
    
            context "multiple messages exist" do
                let!(:messages) {FactoryBot.build_list(:message,5,chat:chat)}
                it "should return array of length 5" do
                    get :index,params:{token: chat_application.token,chatNumber: chat.application_chat_number}
                    expect(response.status).to eq 200
                    expect(response.body.length).to eq 2
                end
            end
        end
    end
    describe "POST create" do
        context "Message created" do
            let!(:chat_application) { FactoryBot.create(:chat_application) }
            let!(:chat) { FactoryBot.create(:chat, chat_application: chat_application) }
            it "should enqueue one job" do
                expect {post :create,params:{token: chat_application.token,chatNumber: chat.application_chat_number}}.to enqueue_job(MessageCreationJob)
            end
        end
    end

    describe "PATCH update" do
        context "Message updated" do 
            let!(:chat_application) { FactoryBot.create(:chat_application) }
            let!(:chat) { FactoryBot.create(:chat, chat_application: chat_application) }
            let!(:message){FactoryBot.create(:message,chat: chat)}
            it "should enqueue one job" do
                expect {patch :update,params:{token: chat_application.token,chatNumber: chat.application_chat_number,messageNumber:message.chat_message_number, body: "changed body"}}.to enqueue_job(EntityUpdateJob)
            end
        end
    end

    describe "DELETE destroy" do
        context "Message deleted" do
            let!(:chat_application) { FactoryBot.create(:chat_application) }
            let!(:chat) { FactoryBot.create(:chat, chat_application: chat_application) }
            let!(:message){FactoryBot.create(:message,chat: chat)}
            it "should enqueue one job" do
                puts chat.application_chat_number,chat_application.token
                expect {delete :destroy,params:{token: chat_application.token,chatNumber: chat.application_chat_number,messageNumber: message.chat_message_number}}.to enqueue_job(EntityDeletionJob)
            end
        end
    end
end