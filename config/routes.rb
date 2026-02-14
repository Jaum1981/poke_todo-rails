Rails.application.routes.draw do
  devise_for :users
  
  root to: "tasks#index"

  resources :tasks do
    member do
      patch :complete
    end
  end

  resources :pokemons, only: [:index] 
  get 'lootbox', to: 'lootbox#index'  
  post 'lootbox/open', to: 'lootbox#open', as: :open_lootbox
end