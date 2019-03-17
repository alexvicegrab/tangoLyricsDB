class Language < ActiveRecord::Base
  has_many :translations
  has_many :songs, through: :translations
  
  # Scopes
  default_scope { order('name') }
  
  # Validations
  validates :iso,
  presence: true,
  uniqueness: { case_sensitive: false },
  length: { is: 2 }
  
  validates :name,
  presence: true,
  uniqueness: { case_sensitive: false },
  length: { minimum: 3 }
    
  # Callbacks
  before_validation :normalise_language, on: [ :create, :update ]
    
  protected
  def normalise_language
    # Remove white space, lower
    self.name = self.name.strip.downcase.titleize unless self.name.blank?
    self.iso = self.iso.strip.downcase unless self.iso.blank?
  end  
  
end
