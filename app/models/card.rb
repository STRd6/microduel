class Card < ActiveRecord::Base
  has_many :card_abilities
  has_many :abilities, :through => :card_abilities

  validates_presence_of :name

  def self.test_card
    if rand(2) == 1
      ability = Ability.find_or_initialize_by_name("Mysticism")
      ability.effect = Ability::Effect.new({:magic => "1*stars + 2*(stars/3)"})
      ability.save!

      card = Card.find_or_initialize_by_name("Mysticism")
      card.abilities = [ability]
      card.save!
    else
      ability = Ability.find_or_initialize_by_name("Magic Missile")
      ability.time_cost = 3
      ability.effect = Ability::Effect.new({:magic => "4*(stars/3)"})
      ability.attack = Ability::Attack.new("3", :magic)
      ability.save!

      card = Card.find_or_initialize_by_name("Magic Missile")
      card.abilities = [ability]
      card.save!
    end

      card
  end
end
