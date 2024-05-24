Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'

  get 'users/dashboard'
  get 'users/items_management'
  get 'users/collections_management'
  get 'users/settings'
  get 'users/admin_page'

  get 'home/index'
  get 'home/collections/listing', to: 'home#collections_listing'
  get 'home/items/listing', to: 'home#items_listing'
  get 'home/item/view', to: 'home#item_view'
  get 'home/collection/view', to: 'home#collection_view'
  get 'change_language', to: 'home#change_language'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
