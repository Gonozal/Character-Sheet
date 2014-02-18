class CreateSkills < ActiveRecord::Migration
  def change
    create_table :skills do |t|
      t.integer :character_id
      t.string :name
      t.integer :trained
      t.string :stat
      t.integer :value

      t.timestamps
    end
  end
end
