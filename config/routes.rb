Semiralabs::Application.routes.draw do

  match 'twilio/incoming' => 'twilio#incoming' 
  match 'twilio/get_token' => 'twilio#capability_token' 

  match 'playdate' => 'games#playdate'
  match 'update_playdate' => 'games#updatePlaydate'

  #deprecated
  match 'update_page' => 'games#updatePage'
  match 'update_from_playdate' => 'games#updateFromPlaydate'
  match 'clear_playdate' => 'games#clearPlaydate'
  match 'disconnect_playdate' => 'games#disconnectPlaydate'
  match 'playdate_requested' => 'games#playdateRequested'
  match 'playdate_disconnected' => 'games#playdateDisconnected'
  
  #currently not used
  match 'memory' => 'games#memory'
  match 'update_game' => 'games#updateGame'
  match 'update_game_from_session' => 'games#updateGameFromSession'
  match 'set_time' => 'games#setTime' #for youtube videos
  match 'check_time' => 'games#checkTime'
  
  match 'feedbacks' => 'feedback#create'
      
  devise_for :users, :controllers => { :sessions => "sessions" }
  resources :users, :only => [:show] do
    collection do
      get 'search'
    end
  end
  resources :friendships
  namespace :api do
    resources :tokens, :only => [:create, :destroy]
    resources :playdatephotos, :only => [:create]
    match 'update_settings' => 'settings#update'
    #resources :settings, :only => [:update]
  end
  
  match 'pusher/auth' => 'pusher#auth'
  
  match 'early_access' => 'application#earlyAccess' 
  match 'timeline' => 'application#timeline'  
  
  authenticated do
    root :to => 'users#show'
  end 
  root :to => 'application#index'
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
