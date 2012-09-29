Semiralabs::Application.routes.draw do 

  match 'playdate' => 'games#playdate'
  match 'update_playdate' => 'games#updatePlaydate'
  match 'feedbacks' => 'feedback#create'
      
  devise_for :users, :controllers => { :sessions => "sessions" }
  resources :users, :only => [:show] do
    collection do
      get 'search'
      get 'allofplaytellsusers'
    end
  end
  match 'remove_user' => 'users#remove'
  match 'remove_earlyuser' => 'users#remove_earlyuser'
  resources :friendships do
    collection do
      post 'add'
    end
  end
  match "remove_friendship" => 'friendships#remove'

  namespace :api do
    resources :tokens, :only => [:create, :destroy]
    resources :playdatephotos, :only => [:create]
    match 'update_settings' => 'settings#update'
    match 'twilio_incoming' => 'twilio#incoming' 
    match 'twilio_token' => 'twilio#capability_token'
    match 'tokbox_tokens' => 'tokbox#tokbox_tokens'
    match 'playdate_players' => 'playdate#playdate_players'
    match 'playdate/redial' => 'playdate#redial'
    match 'playdate/turn_page' => 'playdate#turn_page'
    match 'playdate/change_book' => 'playdate#change_book'
    match 'playdate/close_book' => 'playdate#close_book'
    match 'playdate/finger_tap' => 'playdate#finger_tap'
    match 'playdate/finger_end' => 'playdate#finger_end'
    match 'playdate/create' => 'playdate#create'
    match 'playdate/details' => 'playdate#show'
    match 'playdate/disconnect' => 'playdate#disconnect'
    match 'playdate/join' => 'playdate#join'
    match 'playdate/check_for_playdate' => 'playdate#check_for_playdate'
    match 'playdate/channel_stats' => 'playdate#channel_stats'
    match 'books/list' => 'books#list'
    match 'books/get_nux_book' => 'books#get_nux_book'
    match 'users/all_friends' => 'users#all_friends'
    match 'users/get_status' => 'users#get_status'
    match 'users/create_friendship' => 'users#create_friendship'
    match 'pusher/hook' => 'pusher#hook'
    match 'contacts/create_list' => 'contacts#create_list'
    match 'contacts/show' => 'contacts#show'
    match 'contacts/show_related' => 'contacts#show_related'
    match 'contacts/notify' => 'contacts#notify'
    match 'friendship/create' => 'friendships#create'
    match 'friendship/accept' => 'friendships#accept'
    match 'friendship/decline' => 'friendships#decline'

    match 'games/tictactoe/new_game' => 'tictactoe#new_game'
    match 'games/tictactoe/place_piece' => 'tictactoe#place_piece'
    match 'games/tictactoe/spaces_to_json' => 'tictactoe#spaces_to_json'
    match 'games/tictactoe/indicators_to_json' => 'tictactoe#indicators_to_json'
    match 'games/tictactoe/board_to_json' => 'tictactoe#board_to_json'
    match 'games/tictactoe/end_game' => 'tictactoe#end_game'

    match 'games/memory/new_game' => 'memory#new_game'
    match 'games/memory/play_turn' => 'memory#play_turn'
    match 'games/memory/end_game' => 'memory#end_game'

    match 'contacts/show_related' => 'contacts#show_related'
    match 'contacts/notify' => 'contacts#notify'
    
    
    #resources :settings, :only => [:update]
  end

  match 'activities/list' => 'application#getAllActivities'
  
  match 'pusher/auth' => 'pusher#auth'
  match '/ipad' => 'ipad#index'
  match '/iPad' => 'ipad#index'
  match '/memory' => 'ipad#index'

  
  match 'early_access' => 'application#earlyAccess' 
  match 'timeline' => 'application#timeline'  
  
  authenticated do
    root :to => 'users#show'
  end 
  root :to => 'application#index'
  
  # Books
  resources :books do
    resources :pages
  end
  
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
