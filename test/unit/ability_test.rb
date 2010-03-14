require 'test_helper'

class AbilityTest < ActiveSupport::TestCase
  context "an ability" do
    context "that is passive" do
      setup do
        @ability = Factory :ability
      end

      should "have a bonus" do
        assert @ability.bonus(0, 0)
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

    context "with a passive effect" do
      setup do
        @ability = Factory :ability,
          :star_cost => 0,
          :time_cost => 0,
          :effect => Ability::Effect.new({:magic => "1*stars + 2*at_star_max"})
      end

      should "give the correct calculation of bonus based on star powers" do
        assert_equal 2, @ability.bonus(2, 0)[:magic]
        assert_equal 5, @ability.bonus(3, 1)[:magic]
        assert_equal 0, @ability.bonus(3, 1)[:beans]
      end
    end

    context "without an effect" do
      setup do
        @ability = Factory :ability, :effect => nil
      end

      should "give 0 for bonuses" do
        assert_equal 0, @ability.bonus(2, 0)[:magic]
        assert_equal 0, @ability.bonus(3, 1)[:magic]
        assert_equal 0, @ability.bonus(3, 1)[:beans]
      end
    end

    context "with an activatable effect" do
      setup do
        @ability = Factory :ability,
          :star_cost => 1,
          :effect => Ability::Effect.new({:fire => 3})
      end

      should "give temp bonus when activated" do
        assert_equal 3, @ability.temp_bonus(2, 0)[:fire]
        assert_equal 3, @ability.temp_bonus(3, 1)[:fire]
      end

      should "give 0 for bonuses" do
        assert_equal 0, @ability.bonus(2, 0)[:fire]
        assert_equal 0, @ability.bonus(3, 1)[:fire]
        assert_equal 0, @ability.bonus(3, 1)[:fire]
      end
    end
  end

  context "effect" do
    should "give the correct calculation of star powers" do
      effect = Ability::Effect.new({:magic => "1*stars + 2*at_star_max"})

      assert_equal 2, effect.derived_values(2, 0)[:magic]
      assert_equal 5, effect.derived_values(3, 1)[:magic]
    end
  end

  context "attack" do
    should "give the correct damage based on stars" do
      attack = Ability::Attack.new("2*stars", :acid)

      assert_equal 4, attack.derived_damage(2)
      assert_equal [:acid], attack.types
    end

    should "give the correct damage when a constant integer" do
      attack = Ability::Attack.new(1, :water)

      assert_equal 1, attack.derived_damage(2)
      assert_equal [:water], attack.types
    end
  end
end
