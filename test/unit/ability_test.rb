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

    context "with an ability effect" do
      setup do
        @ability = Factory :ability, :effect => Ability::Effect.new({:magic => "1*stars + 2*at_star_max"})
      end

      should "give the correct calculation of bonus based on star powers" do
        assert_equal 2, @ability.bonus(2, 0)[:magic]
        assert_equal 5, @ability.bonus(3, 1)[:magic]
        assert_equal 0, @ability.bonus(3, 1)[:beans]
      end
    end

    context "without an ability effect" do
      setup do
        @ability = Factory :ability, :effect => nil
      end

      should "give 0 for bonuses" do
        assert_equal 0, @ability.bonus(2, 0)[:magic]
        assert_equal 0, @ability.bonus(3, 1)[:magic]
        assert_equal 0, @ability.bonus(3, 1)[:beans]
      end
    end
  end

  context "ability effect" do
    should "give the correct calculation of star powers" do
      effect = Ability::Effect.new({:magic => "1*stars + 2*at_star_max"})

      assert_equal 2, effect.derived_values(2, 0)[:magic]
      assert_equal 5, effect.derived_values(3, 1)[:magic]
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
