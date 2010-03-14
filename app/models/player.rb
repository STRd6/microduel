class Player < ActiveRecord::Base
  belongs_to :user
  belongs_to :game

  has_many :game_cards, :order => :position

  serialize :temp_bonus

  validates_presence_of :user, :game
  validates_numericality_of :health, :only_integer => true
  validates_numericality_of :star_counters, :only_integer => true, :greater_than_or_equal_to => 0
  validates_numericality_of :time_counters, :only_integer => true, :greater_than_or_equal_to => 0

  delegate :display_name, :to => :user

  before_validation_on_create :link_cards, :prepare_temp_bonus

  def link_cards
    game_cards.each do |card|
      card.player = self
    end
  end

  def health_max
    50
  end

  def speed
    4
  end

  def bonuses
    net_bonuses = Hash.new(0)

    game_cards.map(&:bonus).inject(net_bonuses) do |net_bonus, card_bonus|
      net_bonus.merge!(card_bonus) { |key, net, card| net + card }
    end

    net_bonuses.merge!(temp_bonus) { |key, net, temp| net + temp }
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

  def prepare_temp_bonus
    self.temp_bonus ||= {}
  end
end
