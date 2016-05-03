class DensitiesController < ApplicationController

  def index
    search_density

    @densities = @densities.page params[:page] 

    respond_to do |format|
      format.xlsx 
      format.html
    end
  end
  
  def export
    search_area 
    render xlsx: "index"
  end 

  def export_detail
    search_area 
    render xlsx: "detail"
  end  

  def search_density
    province_id = params[:province_id]
    city_id = params[:city_id]
    station_id = params[:station_id]
    year = params[:year]
    month = params[:month]
    @densities = Density.all 
    if station_id.blank?
      city = City.find(city_id) unless city_id.blank? 
      if city.nil?
        province = Province.find(province_id) unless province_id.blank? 
        @densities = province.densities unless province.nil?
      else
        @densities = city.densities
      end 
    else
      @densities = Station.find(station_id).densities
    end
    
    @densities = @densities.where(year: params[:year]) unless year.nil? 
    @densities = @densities.where(month: params[:month]) unless month.nil? 
 
  end
end
