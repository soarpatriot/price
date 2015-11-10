class Admin::StationsController < Admin::AdminController

  def index 
  end

  def new 
  end

  def edit
    
  end
   
  def syn
    id = 160
    StationWorker.perform_async('bob',1)
   #response = RestClient.get "http://api.cityhub.me/v1/stations/#{id}.json", {params: {id:id, api_key:api_key, signature: signature}}
    # response1 = RestClient.post "http://localhost:9000/v1/stations/#{id}/sync.json", params.to_json, content_type: :json, accept: :json
    render "index"
  end

  def sign_params params,api_secret
    Digest::SHA1.hexdigest(sort_params(params) + api_secret)
  end

  def sort_params params
    sorted_arr = []
    params.keys.sort.map  do | k |
      sorted_arr << "#{k}=#{params[k]}" if k != :signature && k != 'signature'  
    end 
      
    sorted_arr.join("&")
  end
end

