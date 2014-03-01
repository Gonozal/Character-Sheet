class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.integer :character_id
      t.text :text

      t.timestamps
    end
  end
end
