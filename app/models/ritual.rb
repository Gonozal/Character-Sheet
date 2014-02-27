class Ritual < ActiveRecord::Base
  belongs_to :character
  has_many :ritual_attributes
end
