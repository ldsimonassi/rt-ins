Rails.application.routes.draw do

  get 'drivers/new'

  get 'drivers/create'

  get 'drivers/index'

  get 'drivers/delete'

  get 'locations/by_vehicle'

  get 'locations/by_user'

  get 'prices/index'

  get 'versions/index'

  get 'models/index'

  resources :device_models
  resources :tracking_devices
  resources :brands, only: ['index']

  resources :cities, only: ['get', 'index']
  resources :provinces, only: ['get', 'index']
  resources :countries, only: ['get', 'index']
  resources :vehicles, only: ['create', 'new']
  resources :tracks, only: ['create']
 

  get '/brands/:brand_id/models' => 'models#index'
  get '/brands/:brand_id/models/:model_id/versions' => 'versions#index'
  get '/brands/:brand_id/models/:model_id/versions/:version_id/prices' => 'prices#index'

  get '/users/:user_id/locations' => 'locations#by_user'
  get '/users/:user_id/last_locations' => 'locations#last_by_user'

  get 'sessions/new'

  root 'static_pages#home'

  get 'signup' => 'users#new'
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'
  

  get '/dashboard' => 'users#dashboard'
  
  resources :users, only: ['new', 'create', 'dashboard']
  resources :drivers, only: ['new', 'create', 'index', 'delete']

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
