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
  end
end
