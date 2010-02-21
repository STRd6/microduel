require 'test_helper'

class AbilityTest < ActiveSupport::TestCase
  context "an ability" do
    context "that is passive" do
      setup do
        @ability = Factory :ability
      end

      should "have a bonus" do
        assert @ability.bonus
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
  end
end
