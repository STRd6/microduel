class CreateCards < ActiveRecord::Migration
  def self.up
    create_table :cards do |t|
      t.string :name, :null => false, :limit => 30

      t.timestamps :null => false
    end
  end

  def self.down
    drop_table :cards
  end
end
