class Ability < ActiveRecord::Base
  class Effect
    attr_accessor :hash

    def initialize(hash)
      @hash = hash
    end

    def derived_values(stars, at_star_max)
      h = Hash.new(0)

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

  before_validation :prepare_attack
  before_validation :prepare_effect

  def bonus(stars, at_star_max)
    if effect
      effect.derived_values(stars, at_star_max)
    else
      Hash.new(0)
    end
  end

  def attack_damage(stars, bonuses)
    base_damage = attack.derived_damage(stars)

    attack.types.inject(base_damage) do |net_damage, type|
      net_damage + bonuses[type]
    end
  end

  def prepare_attack
    if self.attack.class == Array
      self.attack = Attack.new(*self.attack)
    end
  end

  def prepare_effect
    if self.effect.class == Hash
      self.effect = Effect.new(self.effect)
    end
  end

  def self.generate(name, attributes)
    ability = Ability.find_by_name(name) || Ability.new(:name => name)

    ability.update_attributes!(attributes)
  end

  def self.seed
    types = %w[fire ice magic slash speed]

    types.each do |type|
      generate "#{type} boost", {
        :effect => {:"#{type}" => "4*at_star_max"}
      }
    end

    types.each do |type|
      generate "#{type} boost small", {
        :effect => {:"#{type}" => "2*at_star_max"}
      }
    end

    types.each do |type|
      generate "#{type} gain", {
        :effect => {:"#{type}" => "1*stars"}
      }
    end

    generate "fireball", {
      :attack => [3, :fire, :magic],
      :time_cost => 4,
    }

    generate "firehand", {
      :attack => [1, :fire],
      :time_cost => 2,
    }

    generate "iceblade", {
      :attack => [1, :ice],
      :time_cost => 1,
    }

    generate "lightning", {
      :attack => [4, :lightning, :magic],
      :time_cost => 5,
    }

    generate "magic missile", {
      :attack => [3, :magic],
      :time_cost => 3,
    }

    generate "slash", {
      :attack => [3, :slash],
      :time_cost => 3,
    }
  end
end
