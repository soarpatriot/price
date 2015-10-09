class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


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
    def allow_iframe 
      response.headers["X-FRAME-OPTIONS"] = "ALLOW-FROM https://login.wuliusys.com"
    end
end
