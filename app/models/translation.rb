class Translation < ActiveRecord::Base
  belongs_to :song, counter_cache: true
  
  validates :link,
    presence: true,
    uniqueness: { case_sensitive: false },
    length: { minimum: 15 }
end
