class CreateCharacters < ActiveRecord::Migration
  def change
    create_table :characters do |t|
      t.integer :user_id

      t.integer :level
      t.integer :experience

      t.integer :hit_points
      t.integer :temp_hp, default: 0
      t.integer :current_hp, default: 0
      t.integer :healing_surges
      t.integer :current_hs, default: 0

      t.string :name
      t.decimal :height, precision: 3, scale: 2
      t.decimal :weight, precision: 5, scale: 2
      t.string :gender
      t.integer :age
      t.string :alignment
      t.string :company
      t.string :carried_money
      t.string :stored_money
      t.string :traits
      t.string :appearance
      t.string :notes
      t.string :companions
      t.string :race
      t.string :klass

      t.integer :speed
      t.integer :initiative

      t.integer :ac, null: false
      t.integer :fortitude, null: false
      t.integer :reflex, null: false
      t.integer :will, null: false

      t.integer :strength, null: false
      t.integer :constitution, null: false
      t.integer :dexterity, null: false
      t.integer :intelligence, null: false
      t.integer :wisdom, null: false
      t.integer :charisma, null: false

      t.timestamps
    end
  end
end
