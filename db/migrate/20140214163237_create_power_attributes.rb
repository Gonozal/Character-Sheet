class CreatePowerAttributes < ActiveRecord::Migration
  def change
    create_table :power_attributes do |t|
      t.integer :power_id
      t.integer :display_rule_id
      t.string :name
      t.text :text

      t.timestamps
    end
  end
end
