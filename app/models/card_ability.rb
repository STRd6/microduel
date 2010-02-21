class CardAbility < ActiveRecord::Base
  belongs_to :card
  belongs_to :ability

  validates_presence_of :card, :ability
end
