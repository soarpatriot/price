class AreasController < ApplicationController

  def index
    search_area Area.atypes[:delivery]   
    @areas = @areas.page params[:page] 

    respond_to do |format|
      format.xlsx 
      format.html
    end
  end
  def expressmen
    @area = Area.find(params[:id])
    result = pms_expressmen
    result_hash = JSON.parse(result, {:symbolize_names => true})
    code = result_hash[:code]
    data = result_hash[:data]
    if code.try(:to_i) == 200
      data.each do | e | 
        #h = Hash.new
        ex = Expressman.where(id: e[:employeeId]).first
        if ex.nil?
          ex = Expressman.new 
          ex.id = e[:employeeId]
          ex.name = e[:employeename]
          ex.mobile = e[:cellphone]
        else
          ex.id = e[:employeeId]
          ex.name = e[:employeename]
          ex.mobile = e[:cellphone]
        end
        ex.save
        #logger.info "e :#{h[:id]}"
        #e.delete(:employeeId)
        #e.delete(:employeename)
        #e.delete(:cellphone)
      end 
    end
    redirect_to edit_area_url(@area)
  end  
  def pms_expressmen
    pms_url = Settings.pms_base_url
    role_id = 7
    RestClient.get "#{pms_url}/role/#{role_id}/employees?id=#{role_id}"

  end
  def edit 
    @area = Area.find(params[:id])
    @expressmen = Expressman.all
  end 
  def update 
    @area = Area.find(params[:id])
    
    if @area.update area_params
      redirect_to areas_url
    else
      render "edit"
    end
  end
  def export
    search_area Area.atypes[:delivery]   
    render xlsx: "index"
  end 

  def export_detail
    search_area Area.atypes[:commission]   
    render xlsx: "detail"
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
