Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  root 'tasks#index'
  get 'login' => 'user_sessions#new'
  delete 'logout' => 'user_sessions#destroy'

  resource :user_session, only: :create
  resources :tasks
  resources :labels
  scope :admin do
    resources :users
  end

end
