class Song < ActiveRecord::Base
  include Filterable
  
  belongs_to :genre, counter_cache: true
  has_many :translations, -> { joins(:language).order('languages.iso') }, dependent: :delete_all
  has_many :languages, through: :translations
  
  # Scopes
  default_scope { order('title') }
  
  scope :title_has, -> (title) { where("lower(title) like ?", "%#{I18n.transliterate(title.downcase)}%") }
  scope :composer_has, -> (composer) { where("lower(composer) like ?", "%#{I18n.transliterate(composer.downcase)}%") }
  scope :lyricist_has, -> (lyricist) { where("lower(lyricist) like ?", "%#{I18n.transliterate(lyricist.downcase)}%") }
  scope :genre_is, -> (genre_id) { where("genre_id = ?", genre_id) }
  scope :year_min, -> (year) { where("year >= ?", year) }
  scope :year_max, -> (year) { where("year <= ?", year) }
  scope :translation_num, -> (translations_count) { where("translations_count = ?", translations_count) }
  scope :language_is, -> (language_id) { joins(:translations).merge( Translation.where("language_id = ?", language_id) ) } 
  scope :translator_is, -> (translator_id) { joins(:translations).merge( Translation.where("translator_id = ?", translator_id) ) } 
  
  # Validations
  validates :title,
  presence: true,
  uniqueness: { case_sensitive: false },
  length: { minimum: 2 }
  
  validates :genre_id,
  presence: true,
  numericality: { only_integer: true, greater_than_or_equal_to: 1 }
    
  validates :year,
  allow_nil: true,
  numericality: {only_integer: true, greater_than_or_equal_to: 1866, less_than_or_equal_to: 2014}
  
  validates :composer,
  presence: true,
  length: { minimum: 4 }
      
  validates :lyricist,
  presence: true,
  length: { minimum: 4 }
    
  # Callbacks
  before_validation :normalise_song, on: [ :create, :update ]
    
  protected
  def normalise_song
    # Remove accents, white space, lower, titleise
    self.title = I18n.transliterate(self.title.strip.downcase.titleize) unless self.title.blank?
    
    unless self.composer.blank?
      self.composer = I18n.transliterate(self.composer.strip.downcase.titleize)
      # Fix "D'a" to "D'A" in composer & lyricist
      self.composer = self.composer.gsub("D'a", "D'A")
    end
    
    unless self.lyricist.blank?
      self.lyricist = I18n.transliterate(self.lyricist.strip.downcase.titleize)
      self.lyricist = self.lyricist.gsub("D'a", "D'A")
    end
  end  
end
