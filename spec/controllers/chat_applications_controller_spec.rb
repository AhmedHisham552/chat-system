require "rails_helper"

RSpec.describe ChatApplicationsController,type: :controller do
    describe "GET index" do
        context "No applications" do
            it "should return empty array" do
                get :index
                expect(response.status).to eq 200
                expect(response.body).to eq [].to_json
            end
        end
        context "Applications exist" do
            let!(:chat_application){FactoryBot.create(:chat_application)}
            it "should return the existing applications" do
                get :index
                expect(response.status).to eq 200
                expect(response.body).to eq [{token: chat_application.token,name: chat_application.name}].to_json
            end
        end
    end

    describe "POST create" do
        context "Application created" do
            it "should enqueue one job" do
                expect {post :create}.to enqueue_job(ApplicationCreationJob)
            end
        end
    end

    describe "PATCH update" do
        context "Chat updated" do 
            let!(:chat_application) { FactoryBot.create(:chat_application) }
            it "should enqueue one job" do
                expect {patch :update,params:{token: chat_application.token, name: "changed name"}}.to enqueue_job(EntityUpdateJob)
            end
        end
    end

    describe "DELETE destroy" do
        context "Chat deleted" do
            let!(:chat_application) { FactoryBot.create(:chat_application) }
            it "should enqueue one job" do
                expect {delete :destroy,params:{token: chat_application.token}}.to enqueue_job(EntityDeletionJob)
            end
        end
    end
end