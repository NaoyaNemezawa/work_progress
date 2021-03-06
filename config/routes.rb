Rails.application.routes.draw do
  devise_for :users
  root to: "projects#index"
  resources :projects, only:[:index,:create,:update,:destroy] do
    resources :user_projects, only:[:create]
    resources :tasks, only:[:index,:create,:update,:destroy] do
      resources :comments, only:[:index,:create,:update,:destroy]
    end
  end
end
