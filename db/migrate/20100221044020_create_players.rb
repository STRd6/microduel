class CreatePlayers < ActiveRecord::Migration
  def self.up
    create_table :players do |t|
      t.references :user, :null => false
      t.references :game, :null => false
      t.integer :health, :null => false, :default => 50

      t.timestamps :null => false
    end

    add_index :players, :user_id
    add_index :players, :game_id
  end

  def self.down
    drop_table :players
  end
end
