Rails.application.routes.draw do
  resources :conversations, only: [:index, :show] do
    member do
      get 'messages', to: 'conversations#get_chats'
    end
  end

  resources :chats, path: "messages", only: [:create]
end
