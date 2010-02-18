class UsersController < ResourceController::Base
  actions :all, :except => :destroy  
end
