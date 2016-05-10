class WelcomeController < ApplicationController
  def index
    @domain = Domain.where(domain: request.host_with_port).first
    if @domain.present?
      @places = @domain.google_places
      render template: "spots/places"
    else
      @domains = Domain.all
    end 
  end
end
