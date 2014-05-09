class Translation < ActiveRecord::Base
  belongs_to :song, counter_cache: true
  
  validates :link,
    presence: true,
    uniqueness: { case_sensitive: false },
    length: { minimum: 15 }
    
    # Callbacks
    before_validation :normalise_translation, on: [ :create, :update ]
    
    protected
    def normalise_translation
      # Remove white space, lower
      self.link = self.link.lstrip.downcase
    end  
end
