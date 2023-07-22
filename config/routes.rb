Rails.application.routes.draw do
  namespace :api do
    resources :pokemon
  end
end
