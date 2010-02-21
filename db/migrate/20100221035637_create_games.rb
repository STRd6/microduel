class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
      t.string :name, :null => false
      t.string :state, :null => false
      t.boolean :public, :null => false, :default => true

      t.integer :rotation_offset, :null => false, :default => 0
      t.integer :turn, :null => false, :default => 0

      t.references :active_player
      t.references :priority_player

      t.timestamps :null => false
    end

    add_index :games, :public
  end

  def self.down
    drop_table :games
  end
end
