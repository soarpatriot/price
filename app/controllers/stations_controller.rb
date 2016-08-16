class StationsController < ApplicationController

   before_action :set_station, only: [:update,:edit,:area,:delivery_area,:express,:destroy, :expressmen,:syn_all]

   def index
    search_station
   end

   def men 
    search_station
   end 
   
   def syn_all
    h = Hash.new
    city_desc = @station.try(:stationable).try(:description)
    h[:city] = city_desc 
    h[:work_station] = @station.description
    h[:work_station_code] = @station.id
    h[:work_station_addr_city] = city_desc
    h[:work_station_addr_detail] = @station.address
    h[:cp_code] = "K_RFD" 
    h[:company_name] = "如风达" 
    h[:oper_type] = 0

     @result = [] 
     @station.expressmen.each do |man|
       if man.no_syn? 
        h[:phone] = man.mobile
        h[:cp_user_id] = man.id
        h[:employee_no] = man.code unless man.code.blank?
        h[:name] = man.name
        h[:oper_type] = 0
        h.delete :sign
        signed = sign_params h
        h[:sign] = signed.upcase
        logger.info h.to_json 

        begin  
          resp = RestClient.post Settings.top_url, h
          result_hash = JSON.parse(resp, {:symbolize_names => true})
          is_success =  result_hash[:is_success] 
          h[:is_success] = is_success 
          if is_success 
            man.syned!
            h[:message] = "已同步成功!"
          else 
            h[:message] = "已同步失败!"
          end 
        rescue Exception => e
          h[:is_success] = false
          h[:message] = "果果server 错误，同步失败!"
          logger.info  "exception e:  #{e}"
        end 
        @result << h 
       end
     end  

     render "expressmen"
   end   

   def expressmen 
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

   def sign_params h 
    sign_str = ""
    top_secret = Settings.top_secret
    h.keys.sort.each do |k|
      sign_str << "#{k}#{h[k]}"
    end
    sign_str = top_secret + sign_str + top_secret
    Digest::MD5.hexdigest(sign_str)
  end
  def common_params h
    h[:method] = Settings.top_method
    h[:app_key] = Settings.top_key
    h[:timestamp] = DateTime.now.strftime("%Y-%m-%d %H:%M:%S")
    h[:format] = Settings.top_format
    h[:v] = Settings.top_version
    h[:sign_method] = Settings.top_sign_method
    h 
  end
 
end
