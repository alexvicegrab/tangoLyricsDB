class Translator < ActiveRecord::Base
  has_many :translations
  
  # Scopes
  default_scope { order('name') }
  
  # Validations
  validates :name,
  presence: true,
  length: { minimum: 5 } # No uniqueness validator: The same author might have multiple sites
  
  validates :site_name,
  presence: true,
  length: { minimum: 5 },
  uniqueness: { case_sensitive: false, scope: :name, message: "+ author combination must be unique" } # Different authors might have the same site name
  
  validates :site_link,
  presence: true,
  length: { minimum: 15 },
  uniqueness: { case_sensitive: false},
  url: true
    
  # Callbacks
  before_validation :normalise_translator, on: [ :create, :update ]
    
  protected
  def normalise_translator
    # Remove accents, white space, lower, titleise
    self.name = I18n.transliterate(self.name.lstrip.downcase.titleize)
    self.site_name = I18n.transliterate(self.site_name.lstrip.downcase.titleize)
    self.site_link = self.site_link.lstrip.downcase
  end  
end
