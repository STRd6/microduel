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

      should "be able to allocate time counters" do
        @game.allocate 0 => @game.income
      end

      should "be able to pass priority" do
        priority_player = @game.priority_player
        next_priority_player = (@game.players - [priority_player]).first

        @game.pass_priority

        assert_equal next_priority_player, @game.priority_player
      end
    end
  end
end
