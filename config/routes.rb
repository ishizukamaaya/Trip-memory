Rails.application.routes.draw do

  devise_for :users
  root "homes#index"
  get "home/about" => "homes#about"

  resources :users,only:[:show,:edit,:update,:unsubscribe,:destroy] do
    resources :relationships,only:[:create,:destroy]
    get "followings" => "relationships#followings", as: "followings"
    get "followers" => "relationships#followers", as: "followers"
  end

  resources :post_images do
    resources :favorites,only:[:create,:destroy]
    resources :comments,only:[:create,:destroy]
  end

  resources :tag,only:[:index]

end
