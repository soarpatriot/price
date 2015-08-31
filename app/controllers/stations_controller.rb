class StationsController < ApplicationController

   def index
     @stations = Station.all 
   end
   
   def about
   	 
   end
end
