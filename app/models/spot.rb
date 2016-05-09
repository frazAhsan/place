class Spot < ActiveRecord::Base
  belongs_to :google_place
  after_create :set_slug

  def set_slug
    self.slug = self.name.downcase.gsub(/[!@%&,.-'"]/,'').gsub(" ","-")+"-#{self.id}"
    self.save
  end
end
