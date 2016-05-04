class WelcomeController < ApplicationController
  def index
    @domains = Domain.all
  end
end
