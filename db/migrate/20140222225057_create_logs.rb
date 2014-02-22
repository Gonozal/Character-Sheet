class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.integer :character_id
      t.string :text
      t.string :color

      t.timestamps
    end
  end
end
