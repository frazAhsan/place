class Domain < ActiveRecord::Base
  serialize :keywords
  geocoded_by :address
  after_validation :geocode
  has_many :google_places
  
  after_create :edit_nginx, :fetch_places

  def address
    [city, state].compact.join(', ')
  end

  def fetch_places
    FetchPlaces.perform_async(self.id)
  end

  def edit_nginx
    content = "  server_name "
    Domain.all.map{|d| content+= " "+d.domain}
    content+= ";"
    flag = true
    out_file = File.open("#{Rails.root}/temp.conf", "w+") 
    File.open("/www/conf/sites-available/place.conf", "r") do |f|
      f.each_line do |line|  
        if line.include?("server_name")
          flag = false
          out_file.puts content
        end
        if flag == true
          out_file.puts line
        end
        flag = true
      end  
    end
    out_file.close

    new_file = File.open("/www/conf/sites-available/place.conf", "w+") 
    File.open("#{Rails.root}/temp.conf", "r") do |f|
      f.each_line do |line|  
        new_file.puts line
      end 
    end
    new_file.close
    Nginx.perform_in(2.minutes)
  end
end
