Rails.application.routes.draw do
  get 'comments/index'
  get 'tasks/new'
  devise_for :users
  root to: "projects#index"
  resources :projects, only:[:index,:new,:create,:destroy] do
    resources :user_projects, only:[:new,:create]
    resources :tasks, except:[:show] do
      resources :comments, only:[:index,:create,:destroy]
    end
  end
end
