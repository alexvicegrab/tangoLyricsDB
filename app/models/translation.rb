class Translation < ActiveRecord::Base
  include Filterable
  include UrlHelper
  
  belongs_to :song, counter_cache: true
  belongs_to :language, counter_cache: true
  belongs_to :translator, counter_cache: true
  
  # Scopes
  # Next line overrides scoping in song Model, hence commented out
  # default_scope { order('created_at') }
  
  scope :language_is, -> (language_id) { Translation.where("language_id = ?", language_id) } 
  scope :translator_is, -> (translator_id) { Translation.where("translator_id = ?", translator_id) } 
  
  # Validations
  validates :link,
  presence: true,
  length: { minimum: 15 },
  url: true, # Custom URL validator in app/validators
  uniqueness: { case_sensitive: false, scope: :language_id, message: "+ language combination must be unique" } # Sometimes a page may contain several translations (in different languages)
  
  validates :language_id,
  presence: true,
  numericality: { only_integer: true, greater_than_or_equal_to: 1 }
    
  # Callbacks
  before_validation :normalise_translation, on: [ :create, :update ]
  after_validation :define_translator, :check_link
  
  def self.save_all
    # Useful to check that all translations are valid
    Translation.all.each { |translation| translation.save! }
  end
  
  protected
  def check_link
    self.active = check_url(self.link)
  end
  
  def normalise_translation
    # Remove white space
    self.link = self.link.lstrip
  end
  
  def define_translator
    # Check which translator this translation belongs to
    @translators = Translator.all
    
    @translators.each do |t|
      if self.link.include?(t.site_link)
        self.translator_id = t.id
      end
    end
  end
end
