Rails.application.routes.draw do
  get 'tasks/new'
  devise_for :users
  root to: "projects#index"
  resources :projects, only:[:index,:new,:create,:show, :destroy] do
    resources :user_projects, only:[:new,:create]
    resources :tasks, only:[:new,:create]
  end
end
