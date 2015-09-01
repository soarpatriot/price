class CitiesController < ApplicationController

   def index
     @city = City.new 
     @cities = City.page params[:page]
   end
  
   def province 
     @cities = City.where(province_id: city_params[:province_id]).page params[:page]
   end 

   def about
   	 
   end

   def city_params 
     params.require(:city).permit(:id,:descriptiono, :province_id)
   end
end
