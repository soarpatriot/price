class StationsController < ApplicationController

   before_action :set_station, only: [:update,:edit,:area,:delivery_area,:express,:destroy, :expressmen,:syn_all]

   def index
    search_station
   end

   def men 
    search_imported_station
   end 
   
   def syn_all
     @result = [] 
     @search_result = []
     @station.expressmen.each do |man|
       exist_result= is_exist_in_guoguo man.id        
       exist_result = add_man_extra exist_result, man
       @search_result << exist_result
       unless exist_result[:is_error]   || exist_result[:error_response] || exist_result[:result][:is_success] == false
         h = basic_params_station @station
         man_exist = exist_result[:result][:data]
         if man_exist 
          man.syned!
          h[:oper_type] = 1
         else
          h[:oper_type] = 0
         end
         h[:phone] = man.mobile
         h[:cp_user_id] = man.id
         h[:employee_no] = man.code unless man.code.blank?
         h[:name] = man.name
         h.delete :sign
         signed = sign_params h
         h[:sign] = signed.upcase
         logger.info h.to_json 
        
        h = save_or_update_to_guoguo h
        @result << h 
       
       end
    end

    render "expressmen"
   end   

   def expressmen 
     @search_result = []
     @result = []
   end

   def search_station 
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
   def search_imported_station
     @station = Station.new
     province_id = params[:province_id]
     city_id = params[:city_id]

     @stations = Station.imported 
     if province_id.blank?
       params[:city_id] = ""
       @stations = @stations.page params[:page] 
     else 
       if city_id.blank?
         @stations = Province.find(province_id).stations.imported.page params[:page]  
       else
         @stations = City.find(city_id).stations.imported.page params[:page] 
       end 
     end
 
   end 
   def edit 
   end 

   def express 

   end
   def area 

   end  

   def delivery_area 

   end  
 
   def delivery
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
   
   def basic_params_station station
    h = Hash.new
    h = common_params h
    city_desc = station.try(:stationable).try(:description)
    h[:city] = city_desc 
    h[:work_station] = station.description
    h[:work_station_code] = station.id
    h[:work_station_addr_city] = city_desc
    h[:work_station_addr_detail] = station.address
    h[:cp_code] = "K_RFD" 
    h[:company_name] = "如风达" 
    h

   end
end
