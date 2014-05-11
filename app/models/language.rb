class Language < ActiveRecord::Base
  has_many :translations
  has_many :songs, through: :translations
  
  # Scopes
  default_scope { order('iso') }
  
  # Validations
  validates :iso,
  presence: true,
  uniqueness: { case_sensitive: false },
  length: { is: 2 }
    
  # Callbacks
  before_validation :normalise_language, on: [ :create, :update ]
    
  protected
  def normalise_language
    # Remove white space, lower
    self.iso = self.iso.lstrip.downcase
  end  
  
end
