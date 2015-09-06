class StationsController < ApplicationController

   before_action :set_station, only: [:update,:edit,:area,:destroy]

   def index
     @station = Station.new
     @stations = Station.page params[:page] 
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
    
   def set_station
     @station = Station.find(params[:id])
   end
   def station_params
     params.require(:station).permit(:id,:description, :lantitude, :longitude, :stationable_id, :stationable_type)
   end
end
