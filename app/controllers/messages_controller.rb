class MessagesController < ApplicationController
    before_action :find_application_chat, only: [:show, :update, :create, :index, :search]
    before_action :find_message, only: [:show, :update, :destroy]

    def index
        render json: @chat.messages.as_json(except: [:id,:chat_id])
    end

    def create
        creationMessageNumber = new_message_number
        MessageCreationJob.perform_later(@chat[:id],creationMessageNumber,message_params[:body])
        render json: {messageNumber: creationMessageNumber}, status: :created
    end

    def show
        render json: @message.as_json(except: [:id])
    end
    
    def destroy
        MessageDeletionJob.perform_later(@message)
        render status: :ok
    end

    def update
        # Should enqueue a job for updating record
        # @message.update(body: message_params[:body])
        render status: :ok
    end

    def search
        @matches = Message.search(search_query)
        render json: filter_es_response(@matches), status: :ok
    end

    private

    def find_application_chat
        @chat = Chat.joins(:chat_application).where("chat_applications.token =? AND application_chat_number=?",message_params[:token], message_params[:chatNumber]).last!
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

    def search_query
        {
            _source: [:chat_message_number,:body, :created_at],
            query: {
                bool: {
                    must: [
                    {
                        match: {
                            chat_id: @chat[:id]
                        }
                    },
                    {
                        match: {
                            body: params[:query]
                        }
                    }
                    ]
                }
            }
        }
    end

    def filter_es_response(res)
        res.map {|el| el[:_source]}
    end
end

