ActionController::Routing::Routes.draw do |map|
  map.resources :reservations

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
