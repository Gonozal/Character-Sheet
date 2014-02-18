class PowerWeapon < ActiveRecord::Base
  belongs_to :power

  default_scope {order('attack_bonus DESC')}

  def attack_bonus
    a = read_attribute(:attack_bonus)
    (a.present? and a >= 0)? "+#{a}" : a
  end

  def damage_string
    if damage.present? and damage.to_i > 0
      ", #{damage} #{damage_type} damage"
    else
      ""
    end
  end
end
