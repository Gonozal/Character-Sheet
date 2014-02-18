class Power < ActiveRecord::Base
  belongs_to :character
  has_many :power_weapons
  has_many :power_attributes

  default_scope {
    order('power_usage, display').
    includes([:power_weapons, :power_attributes])
  }

  def attack_type
    a = read_attribute(:attack_type)
    (a.present?)? a.titleize.sub("Area Burst", "AB").sub(" Squares", "") : "---"
  end

  def full_attack_type
    read_attribute(:attack_type)
  end
end
