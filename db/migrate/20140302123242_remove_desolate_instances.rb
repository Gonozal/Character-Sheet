class RemoveDesolateInstances < ActiveRecord::Migration
  def up
    # Rest all column information in case someone runs all migrations at once
    Character.reset_column_information
    Feat.reset_column_information
    Item.reset_column_information
    Log.reset_column_information
    PowerAttribute.reset_column_information
    PowerWeapon.reset_column_information
    Power.reset_column_information
    RitualAttribute.reset_column_information
    Ritual.reset_column_information
    Skill.reset_column_information
    User.reset_column_information

    # Start deleting deslote records
    Character.where("user_id NOT IN (SELECT DISTINCT(id) FROM users)").destroy_all
    Character.where("user_id IS NULL").destroy_all
    models = [
      Feat,
      Item,
      Log,
      Power,
      Ritual,
      Skill
    ]
    models.each do |m|
      m.where("character_id NOT IN (SELECT DISTINCT(id) FROM characters)").delete_all
    end

    PowerAttribute.where("power_id NOT IN (SELECT DISTINCT(id) FROM powers)").
      delete_all

    PowerWeapon.where("power_id NOT IN (SELECT DISTINCT(id) FROM powers)").
      delete_all

    RitualAttribute.where("ritual_id NOT IN (SELECT DISTINCT(id) FROM rituals)").
      delete_all
  end
end
