class Log < ActiveRecord::Base
  belongs_to :character

  default_scope {
    limit(8).order("id DESC")
  }
end
