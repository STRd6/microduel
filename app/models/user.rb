class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.require_password_confirmation = false
  end

  #before_validation_on_create :reset_password

  attr_accessible :email, :display_name, :password

  def display_name
    super || "Guest#{id}"
  end
end
