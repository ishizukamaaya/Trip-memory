Rails.application.routes.draw do

  devise_for :users
  root "homes#top"
  get "home/concept" => "homes#concept"

  get "user/unsubscribe" =>"users#unsubscribe"
  resources :users,only:[:show,:edit,:update,:destroy] do
    resources :relationships,only:[:create,:destroy]
    get "followings" => "relationships#followings", as: "followings"
    get "followers" => "relationships#followers", as: "followers"
  end

  resources :post_images do
    resources :comments,only:[:create,:destroy]
    resource :favorites, only:[:create,:destroy]
  end

  resources :tag,only:[:index]

end
