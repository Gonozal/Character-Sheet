class Character < ActiveRecord::Base
  has_many :powers
  has_many :feats
  has_many :skills

  default_scope {
    includes(:powers, :feats, :skills)
  }

  def ability_modifier(ability)
    a = read_attribute(ability.downcase.to_sym).to_i
    a = (a - 10) / 2
  end
end
