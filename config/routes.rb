Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :chat_applications, only:[:create, :index], path: "/applications"

  scope "applications/:token" do
    get "/", to: "chat_applications#show"
    delete "/", to: "chat_applications#destroy"
    patch "/", to: "chat_applications#update"

    scope "/chats" do
      post "/", to: "chats#create"
      get "/", to: "chats#index"
      get "/:chatNumber", to: "chats#show"
      patch "/:chatNumber", to: "chats#update"
      delete "/:chatNumber", to: "chats#destroy"


      scope "/:chatNumber/messages" do
        get "/search",to: "messages#search"
        post "/", to: "messages#create"
        get "/", to: "messages#index"
        get "/:messageNumber", to: "messages#show"
        patch "/:messageNumber", to: "messages#update"
        delete "/:messageNumber", to: "messages#destroy"
      end
    end
  end

  resources :chats
  resources :messages
end
