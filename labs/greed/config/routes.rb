Greed::Application.routes.draw do

  resources :members

  resources :games do |games|
    resources :players
  end

  match 'start_turn/:game_id' => 'turns#start_turn', :as => :start_turn
  match 'game_over/:game_id'  => 'turns#game_over',  :as => :game_over

  match 'non_interactive/:game_id/start' => 'non_interactive_turns#start', :as => :non_interactive_start
  match 'non_interactive/:game_id/results' => 'non_interactive_turns#results', :as => :non_interactive_results

  match 'interactive/:game_id/start'  => 'interactive_turns#roll',   :as => :interactive_start
  match 'interactive/:game_id/roll'   => 'interactive_turns#roll',   :as => :interactive_roll
  match 'interactive/:game_id/bust'   => 'interactive_turns#bust',   :as => :interactive_bust
  match 'interactive/:game_id/decide' => 'interactive_turns#decide', :as => :interactive_decide
  match 'interactive/:game_id/hold'   => 'interactive_turns#hold',   :as => :interactive_hold

  match 'simulate'        => 'simulate_rolls#index',    :as => :simulation_index
  match 'simulate/clear'  => 'simulate_rolls#clear',    :as => :simulation_clear
  match 'simulate/:faces' => 'simulate_rolls#simulate', :as => :simulate_faces_path

  root :to => "games#new"

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

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
