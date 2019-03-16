class Translator < ActiveRecord::Base
  has_many :translations
  
  # Scopes
  default_scope { order('site_name') }
  
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
  after_validation :update_translations, on: [ :update ]
    
  protected
  def normalise_translator
    # Remove accents, white space, lower, titleise
    self.name = I18n.transliterate(self.name.strip.downcase.titleize) unless self.name.blank?
    self.site_name = I18n.transliterate(self.site_name.strip.downcase.titleize) unless self.site_name.blank?
    self.site_link = self.site_link.strip unless self.site_link.blank?
  end

  def update_translations
    # Update dependent translations if the site link changes
    site_link_new = self.site_link
    Rails.logger.debug "self.id #{self.id}"
    site_link_old = Translator.find(self.id).site_link
    
    if site_link_old != site_link_new
      self.translations.each do |t|
        t.update_attribute(:link, t.link.sub(site_link_old, site_link_new))
      end
    end
  end
end
