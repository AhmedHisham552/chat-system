require "rails_helper"

RSpec.describe ChatsController,type: :controller do
    describe "GET index" do
        context "no applications" do
            it "should return no chats" do
                expect { get :index, params:{token: ::SecureRandom.uuid}}.to raise_error(ActiveRecord::RecordNotFound)
            end
        end
        context "applications exist" do
            let!(:chat_application) { FactoryBot.create(:chat_application) }
            context "no chats exist" do
                it "should return no chats" do
                    get :index,params:{token: chat_application.token}
                    expect(response.status).to eq 200
                    expect(response.body).to eq [].to_json
                end
            end

            context "chats exists" do
                let!(:chat) { FactoryBot.create(:chat, chat_application: chat_application) }
                it "should return the chat" do
                    get :index,params:{token: chat_application.token,chatNumber: chat.application_chat_number}
                    expect(response.status).to eq 200
                    expect(response.body).to eq [{name: chat.name, application_chat_number: chat.application_chat_number,messages_count: 0,created_at: chat.created_at,updated_at: chat.updated_at}].to_json
                end
            end
        end
    end

    describe "POST create" do
        context "Chat created" do
            let!(:chat_application) { FactoryBot.create(:chat_application) }
            it "should enqueue one job" do
                expect {post :create,params:{token: chat_application.token}}.to enqueue_job(ChatCreationJob)
            end
        end
    end

    describe "PATCH update" do
        context "Chat updated" do 
            let!(:chat_application) { FactoryBot.create(:chat_application) }
            let!(:chat) { FactoryBot.create(:chat, chat_application: chat_application) }
            it "should enqueue one job" do
                expect {patch :update,params:{token: chat_application.token,chatNumber: chat.application_chat_number, name: "changed name"}}.to enqueue_job(EntityUpdateJob)
            end
        end
    end

    describe "DELETE destroy" do
        context "Chat deleted" do
            let!(:chat_application) { FactoryBot.create(:chat_application) }
            let!(:chat) { FactoryBot.create(:chat, chat_application: chat_application) }
            it "should enqueue one job" do
                expect {delete :destroy,params:{token: chat_application.token,chatNumber: chat.application_chat_number}}.to enqueue_job(EntityDeletionJob)
            end
        end
    end
end