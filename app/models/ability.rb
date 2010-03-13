class Ability < ActiveRecord::Base
  class Effect
    attr_accessor :hash

    def initialize(hash)
      @hash = hash
    end

    def derived_values(stars)
      h = {}

      # TODO: This is seriously dangerous
      hash.each do |key, value|
        h[key] = eval(value)
      end

      h
    end
  end

  class Attack
    attr_accessor :damage, :types

    def initialize(damage, *types)
      @damage, @types = damage, types
    end

    def derived_damage(stars)
      # TODO: This is seriously dangerous
      eval(damage)
    end
  end

  serialize :effect
  serialize :attack

  def bonus(stars)
    effect.derived_values(stars)
  end

  def attack_damage(stars, bonuses)
    base_damage = attack.derived_damage(stars)

    attack.types.inject(base_damage) do |net_damage, type|
      net_damage + bonuses[type]
    end
  end
end
