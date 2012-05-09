Greed::Application.routes.draw do
  resources :games

  resources :members
  root :to => 'members#index'
end
