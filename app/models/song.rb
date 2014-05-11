class Song < ActiveRecord::Base
  include Filterable
  
  belongs_to :genre, counter_cache: true
  has_many :translations, dependent: :destroy
  
  # Scopes
  default_scope { order('title') }
  
  scope :title_has, -> (title) { where("lower(title) like ?", "%#{I18n.transliterate(title.downcase)}%") }
  scope :composer_has, -> (composer) { where("lower(composer) like ?", "%#{I18n.transliterate(composer.downcase)}%") }
  scope :lyricist_has, -> (lyricist) { where("lower(lyricist) like ?", "%#{I18n.transliterate(lyricist.downcase)}%") }
  scope :genre_is, -> (genre_id) { where("genre_id = ?", genre_id) }
  scope :year_min, -> (year) { where("year >= ?", year) }
  scope :year_max, -> (year) { where("year <= ?", year) }
  scope :translation_num, -> (translations_count) { where("translations_count = ?", translations_count) }
  
  # Validations
  validates :title,
  presence: true,
  uniqueness: { case_sensitive: false },
  length: { minimum: 3 }
  
  validates :genre_id,
  presence: true,
  numericality: {only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: Genre.maximum(:id)}
    
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
    self.title = I18n.transliterate(self.title.lstrip.downcase.titleize)
    self.composer = I18n.transliterate(self.composer.lstrip.downcase.titleize)
    self.lyricist = I18n.transliterate(self.lyricist.lstrip.downcase.titleize)
    # Fix "D'a" to "D'A" in composer & lyricist
    self.composer = self.composer.gsub("D'a", "D'A")
    self.lyricist = self.lyricist.gsub("D'a", "D'A")
  end  
end
