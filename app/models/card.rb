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
    generate "Acid Blast",
      "acid blast"

    generate "Chop",
      "slash",
      "slash gain"

    generate "Fireball",
      "fireball",
      "fire gain"

    generate "Firehand",
      "firehand",
      "fire charge"

    generate "Fury",
      "slash",
      "speed gain"

    generate "Iceblade",
      "ice boost",
      "iceblade"

    generate "Kick",
      "kick"

    generate "Lightning",
      "lightning",
      "speed gain"

    generate "Magic Missile",
      "magic boost",
      "magic missile"

    generate "Mysticism",
      "magic boost small",
      "magic gain"

    generate "Slice",
      "slash",
      "slash boost"

    generate "Swiftness",
      "speed boost"
  end

  def self.random(limit=5)
    all :order => "RANDOM()", :limit => limit
  end
end
