class GameCard < ActiveRecord::Base
  belongs_to :card
  belongs_to :player

  has_one :game, :through => :player

  validates_presence_of :card, :player, :position
  validates_numericality_of :position, :only_integer => true, :greater_than_or_equal_to => 0
  validates_numericality_of :star_counters, :only_integer => true, :greater_than_or_equal_to => 0
  validates_numericality_of :time_counters, :only_integer => true, :greater_than_or_equal_to => 0

  delegate :name,
    :abilities,
    :to => :card

  def bonus
    bonus_amounts = Hash.new(0)
    #TODO Static bonus

    #Star bonus
    abilities.each do |ability|
      ability_bonus = ability.bonus(star_counters)
      bonus_amounts.merge!(ability_bonus) {|key, old, new| old + new}
    end

    #TODO Temporal bonus

    return bonus_amounts
  end

  def attacks
    abilities.map(&:attack)
  end

  def do_attack(index)
    ability = abilities.all[index]

    transaction do
      damage = ability.attack_damage(star_counters)

      update_attributes!(
        :time_counters => time_counters - ability.time_cost,
        :star_counters => star_counters - ability.star_cost
      )

      return damage
    end
  end
end
