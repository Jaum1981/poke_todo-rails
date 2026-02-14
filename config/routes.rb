Rails.application.routes.draw do
  
  resources :tasks do
    member do
      patch :complete  # Cria a rota: PATCH /tasks/:id/complete
    end
  end

  get 'home/index'
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  
  # Defines the root path route ("/")
  root "home#index"
end
