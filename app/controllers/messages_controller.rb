class MessagesController < ApplicationController
    before_action :find_application_chat
    before_action :find_message, only: [:show, :update, :destroy]

    def index
        render json: @chat.messages.as_json(except: [:id,:chat_id])
    end

    def create
        creationMessageNumber = message_id_generator
        MessageCreationJob.perform_later(@chat[:id],creationMessageNumber,message_params[:body])
        render json: {messageNumber: creationMessageNumber}, status: :created
    end

    def show
        render json: @message.as_json(except: [:id])
    end
    
    def destroy
        EntityDeletionJob.perform_later(@message)
        render status: :ok
    end

    def update
        EntityUpdateJob.perform_later(@message,{body: message_params[:body]})
        render status: :ok
    end

    def search
        @matches = Message.search(@chat.search_query_generator(message_params[:query]))
        render json: filter_es_response(@matches), status: :ok
    end

    private

    def find_application_chat
        @chat = Chat.joins(:chat_application).where(application_chat_number: message_params[:chatNumber], chat_applications: { token: message_params[:token] }).last!
    end

    def find_message
        @message = Message.where({chat_message_number: message_params[:messageNumber], chat_id: @chat[:id]}).last!
    end

    def message_id_generator
        REDIS.incr message_params[:token]+":"+@chat[:application_chat_number].to_s
    end

    def message_params
        request.parameters.slice(:body,:token,:chatNumber,:messageNumber,:query)
    end

    def filter_es_response(res)
        res.map {|el| el[:_source]}
    end
end

