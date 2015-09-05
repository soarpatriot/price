class CitiesController < ApplicationController

   def index
     @city = City.new 
     unless params[:province_id].blank?
       province_id = params[:province_id]
       @city.province_id = province_id
       @cities = City.where(province_id: province_id).page params[:page] unless province_id.blank?
     else 
       @cities = City.page params[:page]
     end
   end
  
   def province 
     @cities = City.where(province_id: city_params[:province_id]).page params[:page]
   end 

   def map 
     @city = City.find(params[:id])
   end

   def about
   	 
   end

   def city_params 
     params.require(:city).permit(:id,:descriptiono, :province_id)
   end
end
