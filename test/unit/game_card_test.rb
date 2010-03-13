require 'test_helper'

class GameCardTest < ActiveSupport::TestCase
  context "a game card" do
    setup do
      @game_card = Factory :game_card
    end

    should "have time counters" do
      assert @game_card.time_counters
    end

    should "have star counters" do
      assert @game_card.star_counters
    end

    should "have star max" do
      assert @game_card.star_max
    end

    context "with an ability" do
      setup do
        ability = Factory(:ability,
          :effect => Ability::Effect.new({:magic => "1*stars + 2*(stars/3)"})
        )

        @game_card = Factory :game_card,
          :card => Factory(:card,
            :abilities => [ability]
          )
      end

      should "give the correct bonus based on star power" do
        @game_card.update_attribute :star_counters, 2
        assert_equal 2, @game_card.bonus[:magic]

        @game_card.update_attribute :star_counters, 3
        assert_equal 5, @game_card.bonus[:magic]
      end
    end
  end
end
