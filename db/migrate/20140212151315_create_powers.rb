class CreatePowers < ActiveRecord::Migration
  def change
    create_table :powers do |t|
      t.integer :character_id

      t.integer :level, default: 1
      t.string :name
      t.string :display
      t.string :action_type
      t.string :attack_type
      t.string :power_usage
      t.text :flavor
      t.text :requirement
      t.text :keywords

      t.integer :uses, default: 1
      t.integer :used, default: 0
      t.boolean :child, default: false

      # Wizard-only spellbook preparation
      t.boolean :prepared, default: true

      t.timestamps
    end
  end
end
