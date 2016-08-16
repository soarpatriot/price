class AreasController < ApplicationController

  def index
    search_area Area.atypes[:delivery]   
    @areas = @areas.page params[:page] 

    respond_to do |format|
      format.xlsx 
      format.html
    end
  end


  def get_expressmen station_id
    @area = Area.find(params[:id])
    result = pms_expressmen station_id
    result_hash = JSON.parse(result, {:symbolize_names => true})
    code = result_hash[:code]
    data = result_hash[:data]
    expressmen = []
    if code.try(:to_i) == 200
      data.each do | e | 
        #h = Hash.new
        ex = Expressman.where(id: e[:employeeId]).first
        if ex.nil?
          ex = Expressman.new 
          ex.id = e[:employeeId]
          ex.code = e[:employeecode]
          ex.name = e[:employeename]
          ex.mobile = e[:cellphone]
        else
          ex.id = e[:employeeId]
          ex.name = e[:employeename]
          ex.code = e[:employeecode]
          ex.mobile = e[:cellphone]
        end
        ex.save
        #logger.info "e :#{h[:id]}"
        #e.delete(:employeeId)
        #e.delete(:employeename)
        #e.delete(:cellphone)
        expressmen << ex
      end 
    end
    expressmen
    #redirect_to edit_area_url(@area)
  end  
  def pms_expressmen id
    pms_url = Settings.pms_base_url
    RestClient.get "#{pms_url}/expresscompanys/#{id}/employees"

  end
  def edit 
    @area = Area.find(params[:id])
    @expressmen = get_expressmen @area.station_id 
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
  
  def update 
    h = Hash.new 
    h = common_params h
    @area = Area.find(params[:id])
    city_desc = @area.station.try(:stationable).try(:description)
    h[:city] = city_desc 
    h[:work_station] = @area.station.try(:description)
    h[:work_station_code] = @area.code
    h[:work_station_addr_city] = city_desc
    h[:work_station_addr_detail] = @area.station.address
    h[:cp_code] = "K_RFD" 
    h[:company_name] = "如风达" 
    h[:oper_type] = 0
     
    area_str_arr = [] 
    @area.points.each  do |a| 
      area_str_arr << "#{a.longitude},#{a.lantitude}" 
    end
    area_str = area_str_arr.join(";")
    @area.expressmen.each do |man| 
      h[:phone] = man.mobile
      h[:cp_user_id] = man.id
      h[:employee_no] = man.code unless man.code.blank?
      h[:name] = man.name
      h[:oper_type] = 2
      h.delete :sign
      signed = sign_params h
      h[:sign] = signed.upcase
      resp = RestClient.post Settings.top_url, h
      logger.info h.to_json 
      logger.info resp
    end

    @expressmen = Expressman.find(params[:area][:expressman_ids].reject(&:blank?)) 
    @expressmen.each do |man|
      h[:scope] = area_str 
      h[:phone] = man.mobile
      h[:cp_user_id] = man.id
      h[:employee_no] = man.code unless man.code.blank?
      h[:name] = man.name
      h[:oper_type] = 0
      h.delete :sign
      signed = sign_params h
      h[:sign] = signed.upcase
      logger.info h.to_json 
      resp = RestClient.post Settings.top_url, h
      logger.info resp
    end


    # resp = RestClient::Request.execute(method: :post,url: Settings.top_url,
    #                            timeout: 10, payload:h )
    if @area.update area_params
      redirect_to areas_url
    else
      render "edit"
    end
  end
  def export
    search_delivery Area.atypes[:delivery]   
    render xlsx: "index"
  end 

  def export_detail
    search_area Area.atypes[:commission]   
    render xlsx: "detail"
  end  
  def search_delivery atype
    province_id = params[:province_id]
    city_id = params[:city_id]
    station_id = params[:station_id]
    @areas = Area.all
    if station_id.blank?
      city = City.find(city_id) unless city_id.blank? 
      if city.nil?
        province = Province.find(province_id) unless province_id.blank? 
        @areas = province.areas unless province.nil?
      else
        @areas = city.areas
      end 
    else
      @areas = @areas.where(station_id: station_id) 
    end
   
    @areas = @areas.where(atype: atype).joins(:station).includes(:expressmen).includes(:points)
 
  end


  def search_area atype
    province_id = params[:province_id]
    city_id = params[:city_id]
    station_id = params[:station_id]
    created_start = params[:created_start]
    created_end = params[:created_end]
    @areas = Area.all
    if station_id.blank?
      city = City.find(city_id) unless city_id.blank? 
      if city.nil?
        province = Province.find(province_id) unless province_id.blank? 
        @areas = province.areas unless province.nil?
      else
        @areas = city.areas
      end 
    else
      @areas = @areas.where(station_id: station_id) 
    end
   
    @areas = @areas.where(atype: atype) 
    @areas = @areas.where("areas.created_at >= ? ", created_start) unless created_start.blank?
    @areas = @areas.where("areas.created_at <= ? ", created_end) unless created_end.blank?
 
  end

  def area_params
    params.require(:area).permit(:name, :mobile,:id, :code, :expressman_ids=>[])
  end

end
