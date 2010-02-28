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

  def attack_at_damage(card_index, attack_index)
    game_cards.find(card_index).attack_at_damage(attack_index)
  end

  def allocate_stars(allocations)
    transaction do
      total = 0

      allocations.each do |index, quantity|
        total += quantity
        card = game_cards.all[index]
        card.update_attributes!(:star_counters => card.star_counters + quantity)
      end

      update_attributes!(:star_counters => star_counters - total)
    end
  end

  def allocate_time(allocations)
    transaction do
      total = 0

      allocations.each do |index, quantity|
        total += quantity
        card = game_cards.all[index]
        card.update_attributes!(:time_counters => card.time_counters + quantity)
      end

      update_attributes!(:time_counters => time_counters - total)
    end
  end

  def receive_damage(damage)
    update_attributes!(:health => health - [damage, 0].max)
  end
end
