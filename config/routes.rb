Rails.application.routes.draw do
  root 'comics#index'
  get 'add_favorite' => 'comics#add_favorite'
  get 'remove_favorite' => 'comics#remove_favorite'

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
