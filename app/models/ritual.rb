class Ritual < ActiveRecord::Base
  belongs_to :character
  has_many :ritual_attributes, dependent: :delete_all

  default_scope { includes(:ritual_attributes) }
end
