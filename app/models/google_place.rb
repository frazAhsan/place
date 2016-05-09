class GooglePlace < ActiveRecord::Base
  belongs_to :domain
  after_create :set_slug
  has_one :spot

  def set_slug
    self.slug = self.name.downcase.gsub(/[!@%&,.'"]/,'').gsub(" ","-")+"-#{self.id}"
    self.save
  end
end
