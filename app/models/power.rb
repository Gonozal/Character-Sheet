class Power < ActiveRecord::Base
  belongs_to :character
  has_many :power_weapons
  has_many :power_attributes

  ORDERED = ['At-Will', 'Encounter', 'Daily']

  # Returns a case statement for ordering by a particular set of strings
  # Note that the SQL is built by hand and therefore injection is possible,
  # however since we're declaring the priorities in a constant above it's
  # safe.
  def self.order_by_case
    ret = "CASE"
    ORDERED.each_with_index do |p, i|
      ret << " WHEN power_usage = '#{p}' THEN #{i}"
    end
    ret << " END"
  end

  def increase_usage
    self.used += 1 if used < uses
  end

  def decrease_usage
    self.used -= 1 if used > 0
  end

  def available_class
    (available?)? "" : "used"
  end

  def available?
    used < uses or power_usage.downcase == "at-will"
  end

  default_scope {
    order(order_by_case).order(:name).
    includes([:power_weapons, :power_attributes])
  }

  # Make standard attack type shorter, should probably be changed
  def attack_type
    a = read_attribute(:attack_type)
    if a.present?
      a.titleize.sub("Area Burst", "AB").sub(" Squares", "")
    else
      " "
    end
  end

  # attack_type but without str-replace shenanigans
  def full_attack_type
    read_attribute(:attack_type)
  end

  # Attack symbol, maybe better placed in a helper class?
  def attack_type_symbol
    case full_attack_type.titleize
    when /Area Burst.*/
      # atk_area_burst
    when /Area Wall.*/
      # atk_area_wall
    when /Area Blast.*/
      # atk_area_blast
    when /Close Burst.*/
      # atk_close_burst
    when /Close Blast.*/
      # atk_close_blast
    when /Close Wall.*/
      # atk_close_wall
    when /Melee or Ranged Weapon*/
      # atk_hybrid
    when /Ranged Weapon.*/
      # atk_ranged
    when /Ranged.*/
      # atk_ranged_sight
    when /Melee Weapon.*/
      # atk_melee
    when /(Melee Touch)|(Melee).*/
      # atk_touch
    when /Self|Personal.*/
      # atk_personal
    end
  end

  # Action Type symbols, maybe better placed in a helper class?
  def action_type_symbol
    case action_type.titleize
    when "Standard Action"
      "fa-star"
    when "Move Action"
      "fa-arrows"
    when "Minor Action"
      "fa-sun-o"
    when "Free Action"
      "fa-star-o"
    when "Immediate Interrupt"
      "fa-fighter-jet"
    when "Immediate Reaction"
      "fa-fighter-jet"
    else
      ""
    end
  end
end
