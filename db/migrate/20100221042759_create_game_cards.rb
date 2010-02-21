class CreateGameCards < ActiveRecord::Migration
  def self.up
    create_table :game_cards do |t|
      t.references :player, :null => false
      t.references :card, :null => false
      t.integer :position, :null => false
      t.integer :time_counters, :null => false, :default => 0
      t.integer :star_counters, :null => false, :default => 0

      t.timestamps :null => false
    end

    add_index :game_cards, [:player_id, :position], :unique => true
  end

  def self.down
    drop_table :game_cards
  end
end
