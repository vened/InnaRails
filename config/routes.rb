require 'sidekiq/web'
Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  devise_for :admins
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  # config/routes.rb
  authenticate :admin do
    mount Sidekiq::Web => '/sidekiq'
  end
  # get 'pages/index'
  #
  # get 'pages/show'

  root to: 'pages#index'

  post '/pages/deleteTours' => 'pages#delete_tours'
  post '/pages/updateTours' => 'pages#update'
  resources :pages, only: [:index, :show]

  get 'hello_world', to: 'hello_world#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
