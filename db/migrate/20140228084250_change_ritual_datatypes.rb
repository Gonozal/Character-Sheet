class ChangeRitualDatatypes < ActiveRecord::Migration
  def change
    def change
      change_column :rituals, :flavor, :text
      change_column :rituals, :descritpion, :text
    end
  end
end
