class Skill < ActiveRecord::Base
  belongs_to :character

  def value
    v = read_attribute(:value)
    if v > 0
      "+#{v}"
    elsif v == 0
      "±#{v}"
    else
      v
    end
  end
end
