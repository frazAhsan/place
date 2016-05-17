class SpotsController < ApplicationController
  def places
    domain = Domain.where(domain: request.domain)
    if domain.present?
      @places = domain.google_places
    else
      @places = []
    end  
  end

  def details
    @place = Spot.search({slug: params[:id]}).results.map(&:_source).first
  end
end
