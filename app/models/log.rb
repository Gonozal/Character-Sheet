class Log < ActiveRecord::Base
  belongs_to :character

  default_scope {
    limit(12).order("id DESC")
  }
end
