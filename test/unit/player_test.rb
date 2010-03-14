require 'test_helper'

class PlayerTest < ActiveSupport::TestCase
  context "a player" do
    setup do
      game = Factory :game
      game.join(Factory :user)
      @player = game.players.first
    end

    should "be able to allocate star counters" do
      assert_difference "@player.game_cards.first.star_counters", 1 do
        assert_difference "@player.star_counters", -3 do
          assert @player.allocate_stars({0 => 1, 1 => 1, 2 => 1})
          @player.reload
        end
      end
    end

    should "be able to add a temp bonus" do
      assert_difference "@player.bonuses[:fire]", 3 do
        @player.add_temp_bonus :fire => 3
      end
    end

    should "be able to clear a temp bonus" do
      @player.add_temp_bonus :fire => 3

      assert_difference "@player.bonuses[:fire]", -3 do
        @player.clear_temp_bonus
      end
    end
  end
end
