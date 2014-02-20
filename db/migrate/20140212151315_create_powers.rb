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

      t.boolean :child, default: false

      # t.text :flavor
      # t.string :keywords
      # t.string :power_type

      # t.string :target
      # t.string :targets
      # t.string :attack
      # t.string :special
      # t.string :trigger
      # t.text :hit
      # t.text :aftereffect
      # t.text :miss
      # t.text :effect
      # t.string :requirement
      # t.string :sustain_minor
      # t.string :staff_of_defense
      # t.string :thaneborn_triumph
      # t.string :stalker_spirit
      # t.string :standard_action
      # t.string :intrinsic_nature
      # t.string :symbiosis

      t.timestamps
    end
  end
end
