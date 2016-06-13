class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception, prepend:true
  
  before_action  :allow_iframe
  before_action :authorized!
  before_action :authenticate_login! 

  layout :layout_by_signin

  protected 
    def layout_by_signin

      unless cookies[:LoginUserInfo].nil?
        "bare"
      else
        unless user_signed_in?
          "users"
        else 
          "application"
        end
   
      end
    end
     
    def authenticate_login!
      # cookies[:LoginUserInfo] = "aaa"
      if cookies[:LoginUserInfo].nil?
        authenticate_user!
      end
    end
    def authorized!
      cookie_value = cookies[:LoginUserInfo] 
      origin_url_arr = request.original_url.split "?"
      origin_url = origin_url_arr[0]
      logger.info "origin_url: #{origin_url}"
      if Rails.env.production?
        if cookie_value.nil?
          logger.info "cookie_value is nil"
          not_allowed 
          return 
        end
        code = re_pms origin_url, cookie_value
        logger.info "code: #{code}"
        unless code == "200"
          not_allowed 
        end
      end
    end

    def re_pms origin_url, cookie_value
        right_url = "#{Settings.pms_base_url}/right/url?url=#{origin_url}&cookieValue=#{cookie_value}"
        response = RestClient.get right_url
        result_hash = JSON.parse response,:symbolize_names => true
        result_hash[:code]
 
    end
   
    def allow_iframe 
      #response.headers["X-FRAME-OPTIONS"] = "ALLOW-FROM #{Settings.parent_frame}"
      response.headers["Content-Security-Policy"] = "frame-ancestors  *.wltest.com"
      #response.headers["X-FRAME-OPTIONS"] = "GOFORIT"
    end

    def not_allowed
      #redirect_to "/422" 
      render :status => 422, :format => [:html], :layout => false, file: "#{Rails.root}/public/422.html"
      #respond_to do |format|
      #  format.html { render file: "#{Rails.root}/public/422", layout: false, status: 422 }
      #end
    end

end
