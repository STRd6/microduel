class CreateAbilities < ActiveRecord::Migration
  def self.up
    create_table :abilities do |t|
      t.string :name, :null => false, :limit => 32
      t.integer :star_cost, :null => false, :default => 0
      t.integer :time_cost, :null => false, :default => 0
      t.text :effect
      t.text :attack

      t.timestamps :null => false
    end
  end

  def self.down
    drop_table :abilities
  end
end
