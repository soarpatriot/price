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

      if !cookies[:LoginUserInfo].nil? || !cookies[:access_token].nil?
        "bare"
      else
        unless user_signed_in?
          "users"
        else 
          "application"
        end
   
      end
    end

    def current_user_hash 
      unless access_token_value.nil? 
        logger.info "access_token_value: #{access_token_value}"  
        c_hash = {}
        begin 
          url = "#{Settings.pms_base_url}/v2/employees/token?token=#{access_token_value}"
          user = RestClient::Request.execute(method: :get, url: url,
                   timeout: 3, open_timeout: 2)
          #user = RestClient.get "#{price_url}/users/cookie?cookie_value=#{cookie_value}"
          user_hash = JSON.parse user, symbolize_names: true 
          logger.info "user hash #{user_hash.to_json}"
          c_hash[:id]  = user_hash[:employeeid]
          c_hash[:name] = user_hash[:employeename]
          c_hash[:code] = user_hash[:employeecode]
        rescue  Exception => e
          logger.info  "exception e:  #{e}"
        end
        c_hash
 
      else 
        if !cookies[:LoginUserInfo].nil? 
          cookie_value = cookies[:LoginUserInfo]
          user_info cookie_value
        end
      end

    end 
    def authenticate_login!
      # cookies[:LoginUserInfo] = "aaa"
      if cookies[:LoginUserInfo].nil? and cookies[:access_token].nil?
        authenticate_user!
      end
    end
    def authorized!

      origin_url_arr = request.original_url.split "?"
      origin_url = origin_url_arr[0]
   
      logger.info "origin_url: #{origin_url}"
      if access_token_value.nil? 
        cookie_value = cookies[:LoginUserInfo] 
        if Rails.env.production?
          if cookie_value.nil?
            logger.info "cookie_value is nil"
            not_allowed 
            return 
          end
          code = re_pms origin_url, cookie_value
          logger.info "code: #{code}"
          unless code == "200" or code == "4040"
            not_allowed 
          end
        end
      else 
        logger.info "access_token_value: #{access_token_value}"  
        code = pms_right_v2 origin_url, access_token_value
        logger.info "rights v2 code: #{code}"
        unless code == "200" or code == "4040"
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
   
    def pms_right_v2 origin_url, access_token 
      right_url = "#{Settings.pms_base_url}/v2/rights/#{access_token}/url?url=#{origin_url}"
      response = RestClient.get right_url
      result_hash = JSON.parse response,:symbolize_names => true
      result_hash[:code]

    end 

    def allow_iframe 
      response.headers.except! 'X-Frame-Options'
      #response.headers["X-FRAME-OPTIONS"] = "ALLOW-FROM #{Settings.parent_frame}"
      #response.headers["Content-Security-Policy"] = "frame-ancestors  #{Settings.parent_frame}"
      #response.headers["X-FRAME-OPTIONS"] = "GOFORIT"
    end

    def not_allowed
      #redirect_to "/422" 
      render :status => 422, :format => [:html], :layout => false, file: "#{Rails.root}/public/422.html"
      #respond_to do |format|
      #  format.html { render file: "#{Rails.root}/public/422", layout: false, status: 422 }
      #end
    end
    




  #guoguo interface
  def is_exist_in_guoguo user_id
    h = Hash.new
    h = common_params h
    h[:cp_code] = "K_RFD" 
    h[:cp_user_id] = user_id
    h[:method]  = Settings.top_search_man_method
    h.delete :sign
    signed = sign_params h
    h[:sign] = signed.upcase
 
    begin  
      resp = RestClient.post Settings.top_url, h
      result_hash = JSON.parse(resp, {:symbolize_names => true})
      logger.info result_hash 
      result = result_hash[:cainiao_yima_postmaninfo_is_insert_response]
      error_result = result_hash[:error_response]
      h[:result] = result
      h[:error_response] = error_result
    rescue Exception => e
          h[:is_error] = true
          h[:message] = "果果server 错误，查询失败!"
          logger.info  "exception e:  #{e}"
    end
    h 
  end 

  def save_or_update_to_guoguo h
    log_guoguo_opt h
    begin  
      resp = RestClient.post Settings.top_url, h
      result_hash = JSON.parse(resp, {:symbolize_names => true})
      logger.info result_hash 
      success_response = result_hash[:cainiao_yima_postman_info_import_response]
      error_response = result_hash[:error_response]
      if success_response 
        h[:success_response] = success_response
        if success_response[:is_success]
          h[:message] = "已同步成功!"
        else 
          h[:message] = "同步失败!"
        end
      end

      if error_response
        h[:error_response] = error_response
        h[:message] = "同步失败!"
      end 

    rescue Exception => e
      h[:is_success] = false
      h[:message] = "果果server 错误，同步失败!"
      logger.info  "exception e:  #{e}"
    end 
    h
  end

  def add_man_extra h, man
    h[:phone] = man.mobile
    h[:cp_user_id] = man.id
    h[:employee_no] = man.code unless man.code.blank?
    h[:name] = man.name
    h
  end

  def sign_params h 
    sign_str = ""
    top_secret = Settings.top_secret
    h.keys.sort.each do |k|
      sign_str << "#{k}#{h[k]}"
    end
    sign_str = top_secret + sign_str + top_secret
    Digest::MD5.hexdigest(sign_str)
  end
  def common_params h
    h[:method] = Settings.top_method
    h[:app_key] = Settings.top_key
    h[:timestamp] = DateTime.now.strftime("%Y-%m-%d %H:%M:%S")
    h[:format] = Settings.top_format
    h[:v] = Settings.top_version
    h[:sign_method] = Settings.top_sign_method
    h 
  end


  def user_new_info access_token 
     access_token 
  end

  def user_info cookie_value
      unless cookie_value.nil?
        price_url = Settings.java_service_url
        begin 
          url = "#{price_url}/users/cookie?cookie_value=#{cookie_value}"
          user = RestClient::Request.execute(method: :get, url: url,
                   timeout: 3, open_timeout: 2)
          #user = RestClient.get "#{price_url}/users/cookie?cookie_value=#{cookie_value}"
          user_hash = JSON.parse user, symbolize_names: true 
        rescue  Exception => e
          logger.info  "exception e:  #{e}"
        end
  
        user_hash
        
      end
  end
  def log_guoguo_opt h 
    logger.info "log into guoguo"
    logger.info h.to_json 
    user = current_user_hash
    logger.info "obtain user"
    logger.info user.to_json
    unless user.nil?  
      logger.info "user not nil"
      logger.info "user id: #{user[:id]}, user name: #{user[:name]}, user code: #{user[:code]}"
      GuoGuoLog.create user_id: user[:id], user_name: user[:name], 
        user_code: user[:code], 
        expressman_id: h[:cp_user_id], 
        gtype: h[:oper_type],
        expressman_code: h[:employee_no],
        expressman_name: h[:name],
        expressman_mobile: h[:phone]
    end
   
  end 

  def access_token_value 
    cookies[:access_token]
  end

end
