Rails.application.routes.draw do
  namespace :api do
    resources :pokemon, only: [:index, :show, :create, :update, :destroy]
  end
end
