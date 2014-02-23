class Character < ActiveRecord::Base
  has_many :powers
  has_many :feats
  has_many :skills
  has_many :logs

  default_scope {
    includes(:powers, :feats, :skills)
  }

  attr_accessor :hp_change, :hs_change

  def ability_modifier(ability)
    a = read_attribute(ability.downcase.to_sym).to_i
    a = (a - 10) / 2
  end

  def long_rest
    self.current_hp = hit_points
    self.current_hs = healing_surges
    self.temp_hp = 0
    powers.each do |p|
      p.used = 0
      p.save
    end

    log = {text: "Took an extended rest", color: "green"}
    logs.create(log)
  end

  def short_rest(amount, hs_change)
    self.current_hp = [hit_points, current_hp + amount].min
    self.current_hs = [healing_surges, current_hs - hs_change, 0].sort[1]
    self.temp_hp = 0
    powers.each do |p|
      if p.power_usage.downcase == "encounter"
        p.used = 0
        p.save
      end
    end

    log = {text: "Took a short rest", color: "green"}
    logs.create(log)
  end

  def set_temp_hp(amount)
    self.temp_hp = amount
    hp_log = {text: "Received #{amount} Temporary HP", color: "green"}
    logs.create(hp_log)
  end

  def damage(amount)
    original_amount = amount
    if amount > temp_hp
      amount -= temp_hp
      self.temp_hp = 0
      self.current_hp -= amount
    elsif amount < temp_hp
      self.temp_hp -= amount
    else
      self.temp_hp = 0
    end

    hp_log = {text: "Took #{original_amount} Damage", color: "red"}
    logs.create(hp_log) if amount > 0
  end

  def heal(amount, hs_change)
    self.current_hp = [hit_points, current_hp + amount].min
    self.current_hs = [healing_surges, current_hs - hs_change, 0].sort[1]

    hp_log = {text: "Healed #{amount} HP", color: "green"}
    hs_log = {text: "Used #{hs_change} HS", color: "red"}
    logs.create(hp_log) if current_hp_changed?
    logs.create(hs_log) if current_hs_changed?
  end
end
