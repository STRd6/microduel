class Card < ActiveRecord::Base
  has_many :card_abilities
  has_many :abilities, :through => :card_abilities

  validates_presence_of :name
  
  def self.generate(name, *abilities)
    card = Card.find_by_name(name) || Card.new(:name => name)
    
    card.abilities = abilities.map {|ability_name| Ability.find_by_name(ability_name)}
    
    card.save!
  end

  def self.seed
    generate "Magic Missile",
      "magic boost",
      "magic missile"

    generate "Mysticism",
      "magic boost small",
      "magic gain"
  end

  def self.random
    first :order => "RANDOM()"
  end
end
