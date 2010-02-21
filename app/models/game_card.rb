class GameCard < ActiveRecord::Base
  belongs_to :card
  belongs_to :player

  has_one :game, :through => :player

  validates_presence_of :card, :player, :position
  validates_numericality_of :position, :only_integer => true, :greater_than_or_equal_to => 0
end
