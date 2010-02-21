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
  end
end
