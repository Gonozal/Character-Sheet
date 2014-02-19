class CreatePowerWeapons < ActiveRecord::Migration
  def change
    create_table :power_weapons do |t|
      t.integer :power_id
      t.string :name
      t.integer :attack_bonus
      t.string :damage
      t.string :damage_type, default: "untyped"
      t.string :defense
      t.string :hit_components
      t.string :damage_components

      t.timestamps
    end
  end
end
