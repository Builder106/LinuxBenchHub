Rails.application.routes.draw do
  get "pages/about"
   # Define routes for benchmarks with additional collection routes
   resources :benchmarks, only: [:index, :show, :new, :create] do
     collection do
       get 'debian'
       get 'fedora'
       get 'ubuntu'
     end
   end
 
   # Define the About page route
   get 'about', to: 'pages#about', as: 'about'
 
   # Optionally, remove or keep the following line if 'performance_benchmarks' is a separate resource
   # resources :performance_benchmarks, only: [:index, :show, :new, :create]
 
   # Define the root path route ("/")
   root "benchmarks#index"
 
   # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
   # Can be used by load balancers and uptime monitors to verify that the app is live.
   get "up" => "rails/health#show", as: :rails_health_check
 
   # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
   # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
   # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
 end