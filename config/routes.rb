ActionController::Routing::Routes.draw do |map|
  map.login "login", :controller => "user_sessions", :action => "new"
  map.logout "logout", :controller => "user_sessions", :action => "destroy"

  map.resources :user_sessions
  map.resources :users, :except => :destroy

  map.resources :games, :except => [:edit, :update, :destroy],
    :member => {
      :join => :post,
      :pass_priority => [:get, :post],
      :start => [:get, :post],
      :allocate => [:post],
    }

  map.root :users
end
