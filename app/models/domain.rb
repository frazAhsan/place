class Domain < ActiveRecord::Base
  serialize :keywords
  geocoded_by :address
  after_validation :geocode
  has_many :google_places
  
  after_create :fetch_places

  def address
    [city, state].compact.join(', ')
  end

  def fetch_places
    FetchPlaces.perform_async(self.id)
  end
end
