class Card < ActiveRecord::Base
  has_many :card_abilities
  has_many :abilities, :through => :card_abilities

  validates_presence_of :name

  def self.test_card
    Card.find_or_create_by_name "Test"
  end
end
