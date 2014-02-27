class AddFilenameToCharacter < ActiveRecord::Migration
  def change
    change_table :characters do |t|
      t.string :file_name
    end
  end
end
