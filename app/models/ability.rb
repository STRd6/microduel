class Ability < ActiveRecord::Base
  def bonus
    effect
  end
end
