class ChangeRitualDatatypesAgain < ActiveRecord::Migration
  def change
    change_column :rituals, :flavor, :text
    change_column :rituals, :description, :text
  end
end
