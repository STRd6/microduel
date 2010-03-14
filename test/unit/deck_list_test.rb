require 'test_helper'

class DeckListTest < ActiveSupport::TestCase
  context "deck list" do
    should "only be valid with exactly five cards" do
      deck_list = Factory.build :deck_list, :cards => Card.random

      assert deck_list.save

      deck_list.cards = []

      assert_equal false, deck_list.save
    end
  end
end
