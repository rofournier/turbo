Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do  
    get '/users/sign_out' => 'devise/sessions#destroy'     
 end
  root "dashboard#index"
  resources :todos do
    member do
      patch "strike", to: "todos#strike"
    end
  end
  resources :messages
  resources :tasks do
    member do
      patch :start
      patch :stop
    end
  end
end
