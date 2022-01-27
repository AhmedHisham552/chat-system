class ChatsController < ApplicationController
    before_action :find_application, only: [:show, :update, :create, :index]
    before_action :find_chat, only: [:show, :update, :destroy]

    def index
        render json: @application.chats.as_json(except: [:id,:chat_application_id])
    end

    def create
        creationChatNumber = new_chat_number
        ChatCreationJob.perform_later(@application[:id],creationChatNumber)
        render json: {chatNumber: creationChatNumber}, status: :created
    end

    def show
        render json: @chat.as_json(except: [:id])
    end
    
    def destroy
        # Should enqueue a job for destroying the record
        @chat.destroy
        render status: :ok
    end

    def update
        # Should enqueue a job for updating record
        # @chat.update(application_params)
        render status: :ok
    end

    private

    def find_application
        @application = ChatApplication.find_by_token!(params[:token])
    end

    def find_chat
        @chat = Chat.find(application_chat_number: params[:chat_number], chat_application_id: @application[:id])
    end

    def new_chat_number
        REDIS.multi do |transaction|
            transaction.incr @application.token
        end [0]
    end

    def chat_params
        request.parameters.slice(:token,:chatNumber)
    end
end
