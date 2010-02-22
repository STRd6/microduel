class Player < ActiveRecord::Base
  belongs_to :user
  belongs_to :game

  has_many :game_cards, :order => :position

  validates_presence_of :user, :game
  validates_numericality_of :health, :only_integer => true
  validates_numericality_of :star_counters, :only_integer => true, :greater_than_or_equal_to => 0
  validates_numericality_of :time_counters, :only_integer => true, :greater_than_or_equal_to => 0

  delegate :display_name, :to => :user

  before_validation_on_create :link_cards

  def link_cards
    game_cards.each do |card|
      card.player = self
    end
  end

  def health_max
    50
  end

  def allocate_stars(allocations)
    transaction do
      total = 0

      allocations.each do |index, quantity|
        total += quantity
        card = game_cards.all[index]
        card.increment!(:star_counters, quantity)
      end

      increment!(:star_counters, -total)
    end
  end

  def allocate_time(allocations)
    transaction do
      total = 0

      allocations.each do |index, quantity|
        total += quantity
        card = game_cards.all[index]
        card.increment!(:time_counters, quantity)
      end

      increment!(:time_counters, -total)

      save!
    end
  end
end
