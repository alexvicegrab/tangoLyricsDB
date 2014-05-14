class Translation < ActiveRecord::Base
  belongs_to :song, counter_cache: true
  belongs_to :language, counter_cache: true
  belongs_to :translator, counter_cache: true
  
  # Scopes
  default_scope { order('created_at') }
  
  # Validations
  validates :link,
  presence: true,
  length: { minimum: 15 },
  url: true, # Custom URL validator in app/validators
  uniqueness: { case_sensitive: false, scope: :language_id, message: "+ language combination must be unique" } # Sometimes a page may contain several translations (in different languages)
  
  validates :language_id,
  presence: true,
  numericality: {only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: Language.maximum(:id)}
    
  # Callbacks
  before_validation :normalise_translation, on: [ :create, :update ]
  after_validation :define_translator
    
  protected
  def normalise_translation
    # Remove white space, lower
    self.link = self.link.lstrip.downcase
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
