class CreateDisplayRules < ActiveRecord::Migration
  def change
    create_table :display_rules do |t|
      t.string :name
      t.integer :display_order
      t.string :formatting

      t.timestamps
    end
  end
end
