class Card < ActiveRecord::Base
  has_many :card_abilities
  has_many :abilities, :through => :card_abilities

  validates_presence_of :name

  def self.test_card
    ability = Ability.find_or_initialize_by_name("Mysticism")
    ability.effect = Ability::Effect.new({:magic => "1*stars + 2*(stars/3)"})
    ability.save!

    card = Card.find_or_initialize_by_name("Mysticism")
    card.abilities = [ability]
    card.save!

    card
  end
end
