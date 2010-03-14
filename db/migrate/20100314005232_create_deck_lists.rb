class CreateDeckLists < ActiveRecord::Migration
  def self.up
    create_table :deck_lists do |t|
      t.string :name, :null => false, :limit => 32
      t.references :user, :null => false
      t.text :card_data, :null => false

      t.timestamps :null => false
    end

    add_index :deck_lists, :user_id
    add_index :deck_lists, [:name, :user_id], :unique => true
  end

  def self.down
    drop_table :deck_lists
  end
end
