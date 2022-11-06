Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :instructors, only: [:create, :index, :show, :update, :destroy] do
    resources :students, only: [:create, :update]
  end

  resources :students, only: [:index, :show, :destroy]

end
