class ExpressmenController < ApplicationController
  
  def index 
    @expressmen = Expressman.where(etype: Expressman.etypes[:imported])
  end
  
  def imports 

    if params[:expressmen]
      uploader = ExpressmanUploader.new

      uploader.store!(params[:expressmen]) 
      workbook = RubyXL::Parser.parse(uploader.file.file)
      sheet1 = workbook.worksheets[0]
      check_result = Expressman.check_xls sheet1  
      if check_result[:has_error]
        redirect_to expressmen_url, alert: check_result[:tips]
      else 
        Expressman.save_xls_expressmen(sheet1)
        redirect_to expressmen_url, alert: '上传保存成功！'
      end 
      
    else

      redirect_to expressmen_url, alert: '请上传文件！'
    end

   #sheet1.sheet_data.each do |row|
    #  logger.info row[0]
    #end
  end

  def guoguo 
    @expressmen = Expressman.imported
    @result = [] 
    @search_result = []
    @expressmen.each do |man|
       exist_result= is_exist_in_guoguo man.id        
       exist_result = add_man_extra exist_result, man
       @search_result << exist_result
       station = man.station
       unless exist_result[:is_error]   || exist_result[:error_response] || exist_result[:result][:is_success] == false
         h = basic_params_station station
         man_exist = exist_result[:result][:data]
         if man_exist 
          man.syned!
          h[:oper_type] = 1
         else
          man.no_syn!
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
         if h[:success_response] 
           if h[:success_response][:is_success]
             man.syned!
           end
         end
 
        @result << h 
       
       end
    end

    render "result"
 
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
