class MessagesController < ApplicationController
    before_action :find_application_chat, only: [:show, :update, :create, :index]
    before_action :find_message, only: [:show, :update, :destroy]

    def index
        render json: @chat.messages.as_json(:except=>:id)
    end

    def create
        # Here we should cache the last number of a chat in a specific application and then enqueue a job to create a chat with an incremented number and then update cache to avoid race condition on chat_number
        # Redis table: {token,last_chat_number}
        creationMessageNumber = new_message_number
        MessageCreationJob.perform_later(@chat[:id],creationMessageNumber,message_params[:body])
        render json: {messageNumber: creationMessageNumber}, status: :created
    end

    def show
        render json: @message.as_json(except: [:id])
    end
    
    def destroy
        # Should enqueue a job for destroying the record
        @message.destroy
        render status: :ok
    end

    def update
        # Should enqueue a job for updating record
        # @message.update(body: message_params[:body])
        render status: :ok
    end

    def find_application_chat
        @chat = Chat.joins(:chat_application).where("chat_applications.token =? AND application_chat_number=?",message_params[:token], message_params[:chatNumber]).last
    end

    def find_message
        @message = Message.find!(chat_message_number: params[:message_number], chat_id: @chat[:id])
    end

    def new_message_number
        REDIS.multi do |transaction|
            transaction.incr message_params[:token]+"/"+@chat[:application_chat_number].to_s
        end [0]
    end

    def message_params
        request.parameters.slice(:body,:token,:chatNumber,:messageNumber)
    end
end

