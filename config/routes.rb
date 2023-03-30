Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  # get '/merchants/find', to: 'merchants/search#show'
  namespace :api do
    namespace :v1 do
      get "/merchants/find", to: "merchants/search#show"
      resources :merchants, only: [:index, :show] do
        get "/items", to: "merchants/items#index"
      end

      resources :items do
        get "/merchant", to: "items/merchants#show"
      end
    end
  end
end
