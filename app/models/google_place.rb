require 'elasticsearch/model'
class GooglePlace < ActiveRecord::Base
  belongs_to :domain
  after_create :set_slug
  has_one :spot

  def set_slug
    self.slug = self.name.downcase.gsub(/[!@%&,.'"-]/,'').gsub(" ","-")+"-#{self.id}"
    self.save
  end

  after_save { logger.debug ["Updating document... ", __elasticsearch__.index_document ].join }
  after_destroy { logger.debug ["Deleting document... ", __elasticsearch__.delete_document].join }
  
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  include Elasticsearch::Model::Indexing
  settings index: { number_of_shards: 1 } do
    mappings dynamic: 'false' do
      indexes :place_id,  type: 'string', :index => :not_analyzed
      indexes :city,      type: 'string', :index => :not_analyzed
      indexes :state,     type: 'string', :index => :not_analyzed
      indexes :name,     type: 'string', :index => :not_analyzed
    end
  end

  def self.search(query = {})
    p query
    # empty search not allowed, for now
    return nil if query.blank?

    # define search definition
    search_definition = {
      query: {
        bool: {
          must: []
        }
      },
      sort: []
    }

    if query[:name].present?
      search_definition[:query][:bool][:must] << {term: {name: query[:name].to_i}}
    end

    if query[:place_id].present?
      search_definition[:query][:bool][:must] << {term: {place_id: query[:place_id]}}
    end

    if query[:state].present?
      search_definition[:query][:bool][:must] << {term: {state: query[:state]}}
    end

    if query[:city].present?
      search_definition[:query][:bool][:must] << {term: {city: query[:city]}}
    end

    __elasticsearch__.search(search_definition)
  end
end
