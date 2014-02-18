class Power < ActiveRecord::Base
  belongs_to :character
  has_many :power_weapons
  has_many :power_attributes

  default_scope {order('power_usage, display')}

  def attack_type
    a = read_attribute(:attack_type)
    (a.present?)? a.titleize.sub("Area Burst", "AB").sub(" Squares", "") : "---"
  end
end
