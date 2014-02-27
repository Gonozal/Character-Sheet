class CreateRituals < ActiveRecord::Migration
  def change
    create_table :rituals do |t|
      t.integer :character_id
      t.string :name
      t.string :category
      t.string :key_skill
      t.string :flavor
      t.string :description
      t.integer :level

      t.timestamps
    end
  end
end
