Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  devise_for :admins
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # get 'pages/index'
  #
  # get 'pages/show'

  root to: 'pages#index'
  resources :pages

  get 'hello_world', to: 'hello_world#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
