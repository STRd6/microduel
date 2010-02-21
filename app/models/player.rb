class Player < ActiveRecord::Base
  belongs_to :user
  belongs_to :game

  has_many :game_cards, :order => :position

  validates_presence_of :user, :game

  delegate :display_name, :to => :user
end
