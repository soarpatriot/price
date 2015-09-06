class HomeController < ApplicationController

   def index
   end
   
   def import 
     Spreadsheet.client_encoding = 'UTF-8'
     province_file = "#{::Rails.root}/lib/assets/province.xls"
     station_file = "#{::Rails.root}/lib/assets/station.xls"
     points_file = "#{::Rails.root}/lib/assets/points.xls"
     province_book = Spreadsheet.open province_file
     station_book = Spreadsheet.open station_file
     points_book = Spreadsheet.open points_file

     province_sheet = province_book.worksheet 0
     station_sheet = station_book.worksheet 0
     points_sheet = points_book.worksheet 0
      
     province_sheet.each_with_index do |row,index |
       if index >= 1
         description = row[1].strip
         province = Province.where(description: description).try(:first)
         if province.nil?
            Province.create description: description
         end
       end
     end

     province_sheet.each_with_index do |row,index |
       if index >= 1
         province_desc = row[1].strip
         city_desc = row[2].strip
         province = Province.where(description: province_desc).first
         city = City.where(description: city_desc).try(:first)
         if city.nil?
           City.create! description: city_desc , province: province
         end
       end
     end
     
     province_sheet.each_with_index do |row,index |
       if index >= 1
         province_desc = row[1].strip
         city_desc = row[2].strip
         station_desc = row[3].strip
         city = City.where(description: city_desc).try(:first)
         station = Station.where(description: station_desc).try(:first)
         if station.nil?
           Station.create! description: station_desc, stationable: city
         end
       end
     end

     station_sheet.each_with_index do |row,index |
       if index >= 1
         station_desc = row[1].strip
         address = row[2].strip
         lant = row[3]
         long = row[4]

         station = Station.where(description: station_desc).try(:first)
         unless station.nil?
           station.update! address: address, lantitude: lant, longitude: long 
         end
       end
     end

     points_sheet.each_with_index do |row,index |
       if index >= 1
         station_desc = row[1].strip

         lant = row[3]
         long = row[2]

         station = Station.where(description: station_desc).try(:first)
         unless station.nil?
           station.points.create! lantitude: lant, longitude: long
         end
         # station.points.create! lantitude: lant, longitude: long
         # station.update! address: address, lantitude: lant, longitude: long 
       end
     end



   end
end
