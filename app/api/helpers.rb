module Shuiguoshe
  module APIHelpers
    def warden
      env['warden']
    end
    
    def max_page_size
      100
    end
    
    def default_page_size
      15
    end
    
    def page_size
      size = params[:size].to_i
      [size.zero? ? default_page_size : size, max_page_size].min
    end
    
    def current_user
      token = params[:token]
      @current_user ||= User.where(private_token: token).first
    end
    
    def authenticate!
      error!({"error" => "401 Unauthorized"}, 401) unless current_user
    end
    
    def check_mobile(mobile)
      mobile.gsub(/\s+/, '') =~ /\A1[3|4|5|8][0-9]\d{4,8}\z/
    end
    
  end
end