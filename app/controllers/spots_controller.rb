class SpotsController < ApplicationController
  def places
    @domain = Domain.find(params[:id])
    if !$redis.get("#{@domain.latitude},#{@domain.longitude}").present? 
      keywords = []
      keywords = @domain.keywords.split(",") if @domain.keywords.present?
      array = []
      base_url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{@domain.latitude},#{@domain.longitude}&key=#{ENV['API_KEY']}"
      keywords.each_with_index do |keyword, index|
        array = keywords[0..index].compact.join("+").gsub(" ","_")
        @places = HTTParty.get(base_url+"&keyword=#{array}&radius=25")
        @places = @places["results"]
        if @places.count > 10
          break
        end
      end
      if @places.count < 10
        12.times do |index|
          index+=1
          radius = 100*index
          @places = HTTParty.get(base_url+"&keyword=#{array}&radius=#{radius}")
          @places = @places["results"]
          if @places.count > 10
            break
          end
        end
      end
      $redis.set("#{@domain.latitude},#{@domain.longitude}", @places.to_json)
    else
      @places = JSON.parse($redis.get("#{@domain.latitude},#{@domain.longitude}"))
    end
  end

  def details
    @place = HTTParty.get("https://maps.googleapis.com/maps/api/place/details/json?placeid=#{params[:id]}&key=#{ENV['API_KEY']}")["result"]
  end
end
