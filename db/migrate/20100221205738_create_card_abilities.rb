class CreateCardAbilities < ActiveRecord::Migration
  def self.up
    create_table :card_abilities do |t|
      t.references :card, :null => false
      t.references :ability, :null => false

      t.timestamps :null => false
    end

    add_index :card_abilities, :card_id
    add_index :card_abilities, :ability_id
  end

  def self.down
    drop_table :card_abilities
  end
end
