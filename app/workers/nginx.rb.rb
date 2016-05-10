class Nginx 
  include Sidekiq::Worker 
  
  sidekiq_options :queue => :nginx

  def perform
    system("sudo -S service nginx restart")
  end
end