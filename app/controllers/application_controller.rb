class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  before_action :authenticate_login!

  layout :layout_by_signin

  protected 
    def layout_by_signin
      unless user_signed_in?
        "users"
      end
    end
     
    def authenticate_login!
      if cookies[:LoginUserInfo].nil?
        authenticate_user!
      end
    end
end
