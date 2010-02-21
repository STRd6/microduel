class User < ActiveRecord::Base
  acts_as_authentic

  before_validation_on_create :reset_password

  attr_accessible :email, :display_name

  def display_name
    super || "Guest#{id}"
  end
end
