class DeckList < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :user
  validates_uniqueness_of :name, :scope => :user_id
  validate :must_be_legal

  serialize :card_data

  before_validation_on_create :initialize_card_data

  def initialize_card_data
    self.card_data ||= []
  end

  def cards
    Card.find card_data
  end

  def cards=(card_list)
    self.card_data = card_list.map(&:id)
  end

  def must_be_legal
    errors.add_to_base("Must have exactly 5 cards") unless cards.size == 5
  end
end
