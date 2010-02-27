require 'test_helper'

class AbilityTest < ActiveSupport::TestCase
  context "an ability" do
    context "that is passive" do
      setup do
        @ability = Factory :ability
      end

      should "have a bonus" do
        assert @ability.bonus(0)
      end
    end

    context "that is active" do
      setup do
        @ability = Factory :ability
      end

      should "have a time cost" do
        assert @ability.time_cost
      end

      should "have a star cost" do
        assert @ability.star_cost
      end
    end

    context "with an ability effect" do
      setup do
        @ability = Factory :ability, :effect => Ability::Effect.new({:magic => "1*stars + 2*(stars/3)"})
      end

      should "give the correct calculation of bonus based on star powers" do
        assert_equal 2, @ability.bonus(2)[:magic]
        assert_equal 5, @ability.bonus(3)[:magic]
      end
    end
  end

  context "ability effect" do
    should "give the correct calculation of star powers" do
      effect = Ability::Effect.new({:magic => "1*stars + 2*(stars/3)"})

      assert_equal 2, effect.derived_values(2)[:magic]
      assert_equal 5, effect.derived_values(3)[:magic]
    end
  end

  context "ability attack" do
    should "give the correct damage" do
      attack = Ability::Attack.new("2*stars", :acid)

      assert_equal 4, attack.derived_damage(2)
      assert_equal [:acid], attack.types
    end
  end
end
