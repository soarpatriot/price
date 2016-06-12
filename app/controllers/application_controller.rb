class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception, prepend:true
  
  before_action :authorized!
  before_action :authenticate_login! 
  after_action  :allow_iframe

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
      origin_url = request.original_url
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
      response.headers["X-FRAME-OPTIONS"] = "ALLOW-FROM https://login.wuliusys.com"
    end

    def not_allowed
      respond_to do |format|
        format.html { render file: "#{Rails.root}/public/422", layout: false, status: :not_allowed }
      end
    end

end
