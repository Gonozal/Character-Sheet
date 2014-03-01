class AddWealthToCharacters < ActiveRecord::Migration
  def change
    change_table :characters do |t|
      t.integer :cp, default: 0
      t.integer :sp, default: 0
      t.integer :gp, default: 0
      t.integer :pp, default: 0
      t.integer :ad, default: 0
    end
  end
end
