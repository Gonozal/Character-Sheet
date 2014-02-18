class Character < ActiveRecord::Base
  has_many :powers
  has_many :feats
  has_many :skills
end
