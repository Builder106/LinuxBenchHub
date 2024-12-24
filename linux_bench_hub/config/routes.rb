Rails.application.routes.draw do
   # Devise routes for User authentication
   devise_for :users
 
   # Root path
   root "performance_benchmarks#index"
 
   # Dashboard route
   get 'dashboard', to: 'dashboard#index', as: 'dashboard'
 
   # About page route
   get 'about', to: 'pages#about', as: 'about'
 
   # Resources for Performance Benchmarks with additional collection routes
   resources :performance_benchmarks, only: [:index, :show, :new, :create] do
     collection do
       get 'debian'
       get 'fedora'
       get 'ubuntu'
     end
   end
 
   # Health check route
   get "up" => "rails/health#show", as: :rails_health_check
 
   # Uncomment the following lines if you implement PWA features
   # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
   # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
 end