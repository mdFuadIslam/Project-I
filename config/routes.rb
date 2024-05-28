Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'

  get 'users/dashboard'
  get 'users/items_management'
  get 'users/collections_management'
  get 'users/collection_creation_form'
  get 'users/view_collection'
  get 'users/settings'
  get 'users/admin_page', to: 'users#admin_page'
  post 'users/submited/choice', to: 'users#manage'
  get 'users/admin_user_view', to: 'users#admin_user_view'
  get 'users/create_item'
  get 'users/view_item'

  post 'users/create/collection', to: 'users#create_collection'
  post 'users/edit/collection', to: 'users#edit_collection'
  post 'users/create_item', to: 'users#create_item'
  post 'users/edit/item', to: 'users#edit_item'

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
