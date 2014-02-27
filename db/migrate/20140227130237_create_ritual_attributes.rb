class CreateRitualAttributes < ActiveRecord::Migration
  def change
    create_table :ritual_attributes do |t|
      t.integer :ritual_id
      t.string :name
      t.text :text

      t.timestamps
    end
  end
end
