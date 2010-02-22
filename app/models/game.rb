class Game < ActiveRecord::Base
  has_many :players

  belongs_to :active_player, :class_name => "Player"
  belongs_to :priority_player, :class_name => "Player"

  has_many :game_events
  belongs_to :current_event

  named_scope :open, :conditions => {:state => "open"}

  include AASM

  aasm_column :state

  aasm_state :open, :exit => :start_game
  aasm_state :allocate_stars_phase, :enter => :roll_stars
  aasm_state :allocate_time_phase
  aasm_state :pre_attack_phase
  aasm_state :attack_phase
  aasm_state :end_of_turn_phase, :exit => :end_turn
  aasm_state :completed

  aasm_event :end_phase do
    transitions :to => :allocate_stars_phase, :from => [:end_of_turn_phase]
    transitions :to => :allocate_time_phase, :from => [:allocate_stars_phase]
    transitions :to => :pre_attack_phase, :from => [:allocate_time_phase]
    transitions :to => :attack_phase, :from => [:pre_attack_phase]
    transitions :to => :end_of_turn_phase, :from => [:attack_phase]
  end

  aasm_event :begin_game do
    transitions :to => :allocate_time_phase, :from => [:open]
  end

  def start_game
    transaction do
      self.rotation_offset = rand(players.size)
      set_active_player

      save!
    end
  end

  def end_turn
    self.turn += 1
    set_active_player
    save!
  end

  def pass_priority
    next_player_index = (players.index(priority_player) + 1) % players.size
    self.priority_player = players[next_player_index]

    if priority_player == active_player
      end_phase
    end

    save!
  end

  def roll_stars
    transaction do
      active_player.increment!(:star_counters, 1)
      if (roll = rand(6)) < 5
        # Allocate automatically
        active_player.allocate_stars({roll => 1})
      end
    end
  end

  def join(user)
    unless players.map(&:user_id).include? user.id
      players.build(:game => self, :user => user, :game_cards => generate_default_game_cards)
    end

    save!
  end

  def income
    4
  end

  def channel
    :"game_#{id}"
  end

  private
  def set_active_player
    next_player_index = (turn + rotation_offset) % players.size
    self.active_player = players[next_player_index]
    self.priority_player = active_player
  end

  def generate_default_game_cards
    (0...5).map do |position|
      GameCard.new(:card => Card.test_card, :position => position)
    end
  end

  def message(text)
    #TODO Persist
    (@messages ||= []) << text
  end
end
