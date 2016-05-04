class SpotsController < ApplicationController
  def places
    @domain = Domain.find(params[:id])
    if !$redis.get("#{@domain.latitude},#{@domain.longitude}").present? 
      keywords = []
      keywords = @domain.keywords.split(",") if @domain.keywords.present?
      keywords.each_with_index do |keyword, index|
        array = keywords[0..index]
        @client = GooglePlaces::Client.new(ENV['API_KEY'])
        @places = @client.spots(@domain.latitude, @domain.longitude, :keywords => array)
        if @places.count > 10
          break
        end
      end
      if @places.count < 10
        @places = @client.spots(@domain.latitude, @domain.longitude, :keywords => keywords, :radius => 100)
      end
      $redis.set("#{@domain.latitude},#{@domain.longitude}", @places.to_json)
    else
      @places = JSON.parse($redis.get("#{@domain.latitude},#{@domain.longitude}"))
    end
  end
end
