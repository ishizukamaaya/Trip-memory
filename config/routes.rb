Rails.application.routes.draw do

  devise_for :users
  root "homes#top"
  get "home/concept" => "homes#concept"

  get "user/unsubscribe" => "users#unsubscribe"
  resources :users, only: [:show, :edit, :update, :destroy] do
    resources :relationships, only: [:create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
    get 'favorite_list' => 'favorites#favorite_list', as: 'favorite_list'
  end

  resources :post_images do
    resources :comments, only: [:create, :destroy]
    resource :favorites, only: [:create, :destroy]
  end

  get "search_tag" => "post_images#search_tag"
  get "search" => "post_images#search"

  resources :chats, only: [:create, :show]


end
