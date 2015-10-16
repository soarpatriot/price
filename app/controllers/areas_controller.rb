class AreasController < ApplicationController

   def index
     @area = Area.new
     province_id = params[:province_id]
     city_id = params[:city_id]

     @areas = Area.all.page params[:page] 
  end
   
end
