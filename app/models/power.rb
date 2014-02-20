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

  default_scope {
    order(order_by_case).order(:name).
    includes([:power_weapons, :power_attributes])
  }

  def attack_type
    a = read_attribute(:attack_type)
    if a.present?
      a.titleize.sub("Area Burst", "AB").sub(" Squares", "")
    else
      " "
    end
  end

  def full_attack_type
    read_attribute(:attack_type)
  end

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
