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
    @search_result = []
    @result = []
    @area = Area.find(params[:id])
    @station_expressmen = get_expressmen @area.station_id 
  end 

 
  def update 
    @area = Area.find(params[:id])
    @station_expressmen = get_expressmen @area.station_id 
    @station_id = params[:station_id]
    @city_id = params[:city_id]
    @province_id = params[:province_id]
    area_str_arr = [] 
    @area.points.each  do |a| 
      area_str_arr << "#{a.longitude},#{a.lantitude}" 
    end
    area_str = area_str_arr.join(";")

    @result = [] 
    @search_result = []
    ids = params[:man_ids].split(",")
    @expressmen = Expressman.find(ids) 
    # @expressmen = Expressman.find(params[:man_ids].reject(&:blank?)) 
    @expressmen.each do |man|
       exist_result= is_exist_in_guoguo man.id        
       exist_result = add_man_extra exist_result, man
       @search_result << exist_result
       unless exist_result[:is_error]   || exist_result[:error_response] || exist_result[:result][:is_success] == false

         h = basic_params @area     
         man_exist = exist_result[:result][:data]
         if man_exist 
          man.syned!
          h[:oper_type] = 1
         else
          h[:oper_type] = 0
         end
         h[:scope] = area_str 
         h[:phone] = man.mobile
         h[:cp_user_id] = man.id
         h[:employee_no] = man.code unless man.code.blank?
         h[:name] = man.name
         h.delete :sign
         signed = sign_params h
         h[:sign] = signed.upcase
         logger.info h.to_json 
         
         h = save_or_update_to_guoguo h
         logger.info "save or update"  
         logger.info h.to_json 
         if h[:success_response] 
           if h[:success_response][:is_success]
             ea = man.express_areas.where(area_id: @area.id ).first
             logger.info "area is nil? #{ea.nil?}"  
             if ea.nil? 
               man.areas << @area
             end 
             man.syned!
             man.save
           end

         end
         @result << h 
       end
    end


    # resp = RestClient::Request.execute(method: :post,url: Settings.top_url,
    #                            timeout: 10, payload:h )
    render "edit"
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
    @areas.unscoped unless atype.nil?
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
  def basic_params area
    h = Hash.new 
    h = common_params h
    city_desc = area.station.try(:stationable).try(:description)
    h[:city] = city_desc 
    h[:work_station] = area.station.try(:description)
    h[:work_station_code] = area.code
    h[:work_station_addr_city] = city_desc
    h[:work_station_addr_detail] = area.station.address
    h[:cp_code] = "K_RFD" 
    h[:company_name] = "如风达" 
    
    h 
 
  end

  def man 
     @area = Area.find(params[:id])
     @station_expressmen = get_expressmen @area.station_id 
     @result = [] 
     @search_result = []
     man = Expressman.find(params[:expressman_id])
     ExpressArea.where(expressman: man, area: @area).delete_all 
=begin     
     exist_result= is_exist_in_guoguo man.id        
     exist_result = add_man_extra exist_result, man
     @search_result << exist_result
     unless exist_result[:is_error]   || exist_result[:error_response] || exist_result[:result][:is_success] == false
       h = basic_params @area
       man_exist = exist_result[:result][:data]
       if man_exist 
         man.no_syn!
         h[:oper_type] = 2
         h[:phone] = man.mobile
         h[:cp_user_id] = man.id
         h[:employee_no] = man.code unless man.code.blank?
         h[:name] = man.name
         h.delete :sign
         signed = sign_params h
         h[:sign] = signed.upcase
         logger.info h.to_json 
        
         h = save_or_update_to_guoguo h
         if h[:success_response] 
           if h[:success_response][:is_success]
             man.no_syn!
           end
         end
 
       end
       @result << h 
    end  
=end
    redirect_to edit_area_url(id: @area.id, 
                              province_id: params[:province_id],
                              station_id: params[:station_id],
                              city_id: params[:city_id])
   end

end
