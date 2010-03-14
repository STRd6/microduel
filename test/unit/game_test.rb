require 'test_helper'

class GameTest < ActiveSupport::TestCase
  context "a game" do
    setup do
      @game = Factory :game
      @game.join(Factory(:user))
      @game.join(Factory(:user))
    end

    should "have five cards for each player" do
      assert_equal 5, @game.players.first.game_cards.count
    end

    should "be able to start" do
      assert @game.begin_game

      assert_equal false, @game.open?
    end

    should "be able to join" do
      assert @game.join(Factory(:user))
    end

    context "that has begun" do
      setup do
        @game.begin_game
      end

      should "be able to pass priority" do
        priority_player = @game.priority_player
        next_priority_player = (@game.players - [priority_player]).first

        @game.pass_priority

        assert_equal next_priority_player, @game.priority_player
      end
    end

    context "temp bonuses" do
      setup do
        @game.state = :end_of_turn_phase
        @game.save!

        @player = @game.players.first

        @player.add_temp_bonus :fire => 3
        @player.save!
      end

      should "be cleared at end of turn" do
        assert_difference "@player.bonuses[:fire]", -3 do
          @game.end_phase
        end
      end
    end
  end
end
