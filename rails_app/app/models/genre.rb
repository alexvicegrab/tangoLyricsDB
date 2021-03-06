class Genre < ActiveRecord::Base
  has_many :songs
  
  # Scopes
  default_scope { order('name') }
  
  # Validations
  validates :name,
  presence: true,
  uniqueness: { case_sensitive: false },
  length: { minimum: 4 }
  
  # Callbacks
  before_validation :normalise_genre, on: [ :create, :update ]
  
  protected
  def normalise_genre
    self.name = self.name.strip.downcase.titleize unless self.name.blank?
  end
end
