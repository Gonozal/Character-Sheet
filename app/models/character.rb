class Character < ActiveRecord::Base
  belongs_to :user

  has_many :powers
  has_many :feats
  has_many :skills
  has_many :logs
  has_many :rituals
  has_many :items

  default_scope {
    includes(:feats, :skills)
  }

  validates :ad, numericality: { only_integer: true }
  validates :pp, numericality: { only_integer: true }
  validates :gp, numericality: { only_integer: true }
  validates :sp, numericality: { only_integer: true }
  validates :cp, numericality: { only_integer: true }

  accepts_nested_attributes_for :items, allow_destroy: true

  attr_accessor :hp_change, :hs_change
  before_save :generate_stat_logs

  def hp_class
    if dying?
      "text-error"
    elsif bloodied?
      "text-warning"
    else 
      ""
    end
  end

  def spellbook_powers
    return [] if klass != "Wizard"
    Hash[powers.not_child.to_a.select do |p|
      (/^Wizard Attack \d+/ === p.display and p.power_usage == "Daily") or
        /^Wizard Utility \d+/ === p.display
    end.group_by(&:level).sort]
  end

  def bloodied?
    current_hp <= (hit_points / 2)
  end

  def dying?
    current_hp <= 0
  end

  def ability_modifier(ability)
    a = read_attribute(ability.downcase.to_sym).to_i
    a = (a - 10) / 2
  end

  def long_rest(params = {})
    logs.update_all("color = 'muted'")
    # Handle case of wizard's spellbook
    if klass == "Wizard"
      spellbook_powers.each do |lvl, powers|
        powers.each do |power|
          if params.has_key? lvl.to_s.to_sym and power.id == params[lvl.to_s.to_sym].to_i
            power.prepared = true
          else
            power.prepared = false
          end
          power.save if power.changed?
        end
      end
    end
    # Set HP and HS to full
    self.current_hp = hit_points
    self.current_hs = healing_surges
    self.temp_hp = 0

    # Reset all power usages
    powers.each do |p|
      p.used = 0
      p.save if p.changed?
    end

    # Write logs
    logs.create({text: "Took an extended rest", color: "text-info"})
  end

  def short_rest(amount, hs_change)
    # Update HP and HS as if healed
    heal(amount, hs_change)

    # Also reset encounter powers
    powers.each do |p|
      if p.power_usage.downcase == "encounter"
        p.used = 0
        p.save if p.changed?
      end
    end
    logs.create({text: "Took a short rest", color: "text-info"})
  end

  def set_temp_hp(amount)
    self.temp_hp = amount
  end

  def damage(amount)
    # Deduct temporary hp first, then normal hp
    if amount > temp_hp
      amount -= temp_hp
      self.temp_hp = 0
      self.current_hp -= amount
    elsif amount < temp_hp
      self.temp_hp -= amount
    else
      self.temp_hp = 0
    end
  end

  def heal(amount, hs_change, indent = 0)
    # first check if we have enough healing surges
    indent = " indent#{indent}" if indent > 0
    if hs_change > current_hs
      return false
    end
    # Healing always starts from 0 hp
    if amount > 0 and current_hp < 0
      self.current_hp = 0
    end

    # Update HP and HS amount
    self.current_hp = [hit_points, current_hp + amount].min
    self.current_hs = [healing_surges, current_hs - hs_change, 0].sort[1]
  end

  def generate_stat_logs
    # Get values for changed HP and HS
    hp_change = current_hp_changed?? current_hp_change.inject(:-) : 0
    hs_change = current_hs_changed?? current_hs_change.inject(:-) : 0
    thp_change = temp_hp_changed?? temp_hp_change.inject(:-) : 0

    if hp_change < 0
      # Adjust for healing that occurred below 0 hp
      hp_change_adjusted = - [hp_change, current_hp_change[1]].sort[0]
      logs.create(text: "Healed for #{hp_change_adjusted} HP", color: "text-success")
      if current_hp_change[0] < 0
        logs.create(text: "You are no longer dying", color: "text-success")
      end
    elsif hp_change + thp_change > 0
      # Adjust for healing that occurred whith temp hp present
      hp_change_adjusted = hp_change + thp_change
      logs.create(text: "Took #{hp_change_adjusted} Damage", color: "text-error")
      if current_hp < 0
        logs.create(text: "You are now dying", color: "text-error")
      end
    end

    if hs_change < 0
      logs.create(text: "Regained #{- hs_change} Healing Surges", color: "text-success")
    elsif hs_change > 0
      logs.create(text: "Lost #{hs_change} Healing Surges", color: "text-error")
    end

    if thp_change < 0
      logs.create(text: "Gained #{temp_hp_change[1]} Temp HP", color: "text-info")
    end
  end
end
