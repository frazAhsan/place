class FetchPlaces
  include Sidekiq::Worker
  
  sidekiq_options :queue => :places

  def perform(object_id)
    domain = Domain.find(object_id)
    keywords = []
    keywords = domain.keywords.split(",") if domain.keywords.present?
    array = []
    base_url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{domain.latitude},#{domain.longitude}&key=#{ENV['API_KEY']}"
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
    @places.each do |place|
      gp = GooglePlace.new
      gp.domain_id = object_id
      gp.place_id = place['place_id']
      gp.city = domain.city
      gp.state = domain.state
      gp.detail = place.to_json
      gp.name = place['name']
      if gp.save
        spot = HTTParty.get("https://maps.googleapis.com/maps/api/place/details/json?placeid=#{gp.place_id}&key=#{ENV['API_KEY']}")["result"]
        s = Spot.new
        s.detail = spot.to_json
        s.city = domain.city
        s.state = domain.state
        s.google_place_id = gp.id
        s.name = gp.name
        s.place_id = gp.place_id
        s.save
      end
    end

    # do something
  end
end