Rails.application.routes.draw do
  root 'home#index'
  
  get '/help'  => 'home#help', as: :help
  get '/about' => 'home#about', as: :about
  get '/order_help' => 'home#order_help', as: :order_help
  get '/pay_help' => 'home#pay_help', as: :pay_help
  get '/deliver_help' => 'home#deliver_help', as: :deliver_help

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
  
  patch '/users/:user_id/update_address' => 'users#update_address'
  
  resources :products, only: [:index, :show] do
    resources :orders, only: [:new, :create]
    collection do
      # get :search
    end
  end
  resources :line_items
  resources :carts, only: [:show, :destroy]
  get '/cart' => 'carts#show', as: :show_cart
  
  get '/products/search' => 'products#index', as: :search_products
  
  resources :orders, except: [:index, :update, :destroy, :edit] do    
    member do 
      patch :cancel
    end
  end
  get '/checkout' => 'orders#new', as: :checkout
  
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
        patch :unsuggest
        patch :suggest
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
  
  match '*path', via: :all, to: 'home#error_404'
  
end
