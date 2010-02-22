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

  serialize :effect

  def bonus(stars)
    effect.derived_values(stars)
  end
end
