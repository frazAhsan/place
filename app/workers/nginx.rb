class Nginx 
  include Sidekiq::Worker 
  
  sidekiq_options :queue => :nginx

  def perform
    system("sudo -S /etc/init.d/nginx restart")
  end
end