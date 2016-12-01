class StationWorker
  include Sidekiq::Worker

  def perform(name,count)

    api_key = "1111111111" 
    token_result = gen_token 
    unless token_result.nil?
      token_hash = JSON.parse token_result, symbolize_names: true
      access_token = token_hash[:access_token] 
      station_url = "#{Settings.pms_base_url}/v2/expresscompanys/station/rfd?token=#{access_token}"
      points_base_url = "#{Settings.pms_base_url}/v2/expresscompanys"
      response = RestClient.get station_url
      stations = JSON.parse response,:symbolize_names => true
      stations.each do |station|
        
        points = RestClient.get "#{points_base_url}/#{station[:stationable_id]}/points?token=#{access_token}"
        points_arr = JSON.parse points
        
        city_name = station[:city_name]
        city = City.where(description: city_name).first
        

        params = {id:station[:stationable_id] ,api_key: api_key, 
             format:"json",description: station[:name], 
             address: station[:address], points: points_arr, 
             longitude: station[:lng], lantitude: station[:lat]}
        unless city.nil?
          params[:city_id] = city.id
        end
        #signature = sign_params params, api_secret
        # params[:signature]= signature
        response1 = RestClient.post "#{Settings.api_base_url}/stations/#{station[:stationable_id]}/sync.json", params.to_json, content_type: :json, accept: :json
      end
        
    end 



  end

  def gen_token 
    token_url = "#{Settings.auth_url}/oauth2/token"
    client_id = "#{Settings.auth_client_id}"
    client_secret = "#{Settings.auth_client_secret}"
    grant_type = "#{Settings.auth_grant_type}"
    scope = "#{Settings.auth_scope}"
    result = RestClient::Request.execute method: :post,
       url: token_url,
       timeout: 3,
       open_timeout: 2,
       payload: {
        client_id: client_id,
        client_secret: client_secret,
        grant_type: grant_type,
        scope: scope
      }.to_json,
      headers: {
        content_type: :json,
        accept: :json
      }
    result
  end
end
