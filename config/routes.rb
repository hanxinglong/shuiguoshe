Rails.application.routes.draw do
  root 'home#index'

  devise_for :users, path: "account", controllers: {
    registrations: :account,
    sessions: :sessions,
  }
  post "account/update_private_token" => "users#update_private_token", as: 'update_private_token_account'
  
  resources :users, only: [:update]
  resources :messages, only: [:new, :create]
  
  resource :user do
    get :home
    get :orders
    get :edit
    get :points
    
    get '/orders/incompleted', as: :incompleted_orders
    get '/orders/completed'  , as: :completed_orders
    get '/orders/canceled'   , as: :canceled_orders
    get '/orders/search'     , as: :search_orders
    
  end
  
  resources :products do
    resources :orders, only: [:new, :create]
    collection do
      get :search
    end
  end
  
  resources :orders do    
    member do 
      patch :cancel
    end
  end
  
  resources :apartments, only: [:index]
  resources :newsblasts, path: "news", only: [:show]
  
  namespace :cpanel do
    root 'home#index'
    resources :site_configs, only: [:index, :edit, :create, :update, :destroy, :new]
    resources :orders do
      member do
        patch :cancel
        patch :complete
      end
      collection do
        get :search
        get :today_normal
        get :completed
        get :canceled 
      end
    end
    
    resources :banners
    resources :newsblasts
    resources :sidebar_ads
    
    resources :products do
      member do
        patch :upshelf
        patch :downshelf
      end
    end
    
    resources :users do
      member do
        patch :block
        patch :unblock
      end
    end
    resources :product_types
    resources :apartments do
      member do
        patch :open
        patch :close
      end
    end
  end
  
end
