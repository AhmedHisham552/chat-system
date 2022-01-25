class ChatApplicationsController < ApplicationController

    before_action :find_application, only: [:show, :update, :destroy]

    def index
        render json: ChatApplication.all.select(:name,:token).as_json(:except=>:id)
    end

    def create
        # Should create a token and enqueue a new job for creating the application and return the token to the client
        @application = ChatApplication.new(token: ::SecureRandom.uuid, name: params[:name])

        if @application.save!
            render json: {token: @application.token}, status: :created
        end
    end

    def show
        render json: @application.as_json(only: [:name,:token])
    end
    
    def destroy
        # Should enqueue a job for destroying the record
        @application.destroy
        render status: :ok
    end

    def update
        # Should enqueue a job for updating record
        @application.update(application_params)
        render status: :ok
    end

    def find_application
        @application = ChatApplication.find_by_token(params[:token])
    end

    def application_params
        request.parameters.slice(:name)
    end
end
