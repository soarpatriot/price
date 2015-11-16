class StationWorker
  include Sidekiq::Worker

  def perform(name,count)

    api_key = "1111111111"
    station_url = Settings.syn_station_url

    response = RestClient.get station_url
    stations = JSON.parse response,:symbolize_names => true

    stations.each do |station|
      points = RestClient.get "#{station_url}/#{station[:id]}/points"
      points_arr = JSON.parse points
      
      city_name = station[:cityName]
      city = City.where(description: city_name).first
      

      params = {id:station[:id] ,api_key: api_key, 
           format:"json",description: station[:name], 
           address: station[:address], points: points_arr, 
           longitude: station[:lng], lantitude: station[:lat]}
      unless city.nil?
        params[:city_id] = city.id
      end
      #signature = sign_params params, api_secret
      # params[:signature]= signature
      response1 = RestClient.post "#{Settings.api_base_url}/stations/#{station[:id]}/sync.json", params.to_json, content_type: :json, accept: :json
    end
 
  end
end
