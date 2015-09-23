class StationsController < ApplicationController

   before_action :set_station, only: [:update,:edit,:area,:destroy]

   def index
     @station = Station.new
     province_id = params[:province_id]
     city_id = params[:city_id]

     if province_id.blank?
       params[:city_id] = ""
       @stations = Station.page params[:page] 
     else 
       if city_id.blank?
         @stations = Province.find(province_id).stations.page params[:page]  
       else
         @stations = City.find(city_id).stations.page params[:page] 
       end 
     end
   end
   
   def edit 
   end 
   
   def area 

   end
   def update 
     if @station.update station_params
       redirect_to stations_path
     else
       render :edit
     end
   end
   def new 
     @station = Station.new 
   end 

   def create 
     @station = Station.new(station_params) 

     if @station.save
       redirect_to stations_path
     else
       render :new
     end

   end
   def destroy
     @station.destroy
     redirect_to stations_path
   end

   def export 
     @stations = Station.all
   
     render :xlsx => "export"

   end 

   def set_station
     @station = Station.find(params[:id])
   end
   def station_params
     params.require(:station).permit(:id,:description, :lantitude, :longitude, :stationable_id, :stationable_type)
   end
end
