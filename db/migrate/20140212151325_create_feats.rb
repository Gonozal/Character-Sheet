class CreateFeats < ActiveRecord::Migration
  def change
    create_table :feats do |t|
      t.integer :character_id
      t.string :name
      t.text :description
      t.string :short

      t.timestamps
    end
  end
end
