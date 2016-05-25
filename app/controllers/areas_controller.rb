class AreasController < ApplicationController

  def index
    search_area Area.atypes[:delivery]   
    @areas = @areas.page params[:page] 

    respond_to do |format|
      format.xlsx 
      format.html
    end
  end
  
  def edit 
    @area = Area.find(params[:id])
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

    @areas = Area.where(atype: atype) 
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
   
    @areas = @areas.where("areas.created_at >= ? ", created_start) unless created_start.blank?
    @areas = @areas.where("areas.created_at <= ? ", created_end) unless created_end.blank?
 
  end

  def area_params
    params.require(:area).permit(:name, :mobile,:id, :code, :expressman_ids=>[])
  end

end
