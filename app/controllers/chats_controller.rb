class ChatsController < ApplicationController
    before_action :find_application, only: [:show, :update, :create, :index]
    before_action :find_chat, only: [:show, :update, :destroy]

    def index
        render json: @application.chats.as_json(:except=>:id)
    end

    def create
        # Here we should cache the last number of a chat in a specific application and then enqueue a job to create a chat with an incremented number and then update cache to avoid race condition on chat_number
        # Redis table: {token,last_chat_number}
        newChatNumber = new_chat_number
        @chat = Chat.new(chat_application_id: @application[:id],application_chat_number: newChatNumber)

        if @chat.save!
            render json: {chatNumber: newChatNumber}, status: :created
        end
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

    def find_application
        @application = ChatApplication.find_by_token!(params[:token])
    end

    def find_chat
        @chat = Chat.find(application_chat_number: params[:chat_number], chat_application_id: @application[:id])
    end

    def new_chat_number
        lastApplicationChat = @application.chats.last
        newChatNumber = (lastApplicationChat.nil?) ? 1 : lastApplicationChat[:application_chat_number] + 1
    end

    def chat_params
        request.parameters.slice(:token,:chatNumber)
    end
end