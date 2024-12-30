Rails.application.routes.draw do
  get "profiles/edit"
  get "profiles/update"
   # Devise routes for User authentication
   devise_for :users
 
   # Root path
   root "home#index"
 
   # Dashboard route
   get 'dashboard', to: 'dashboard#index', as: 'dashboard'

   # Add the contact route
   get 'contact', to: 'pages#contact', as: 'contact'
   post 'contact', to: 'pages#contact'

   # About page route
   get 'about', to: 'pages#about', as: 'about'

   # Compare benchmarks route
   get 'performance_benchmarks/compare', to: 'performance_benchmarks#compare', as: 'compare_benchmarks'
 
   # Resources for Performance Benchmarks with additional collection routes
   resources :performance_benchmarks, only: [:index, :show, :new, :create, :destroy] do
      member do
        get 'export'
        post 'share'
        # delete 'destroy'
      end
      collection do
        get 'debian'
        get 'fedora'
        get 'ubuntu'
      end
   end

   resources :notifications, only: [:index] do
      member do
        patch 'mark_as_read'
      end
   end
 
   # Health check route
   get "up" => "rails/health#show", as: :rails_health_check
 
   # Uncomment the following lines if you implement PWA features
   # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
   # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
 end