class HomeController < ApplicationController

   def index
   end
   def clear 
     Province.destroy_all
     City.destroy_all
     Station.destroy_all 
     Point.destroy_all

     render "import"
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
      
     points_sheet.each_with_index do |row,index |
       if index >= 1
         station_desc = row[1].strip

         lant = row[3]
         long = row[2]
         station = Station.where(description: station_desc).try(:first)
         unless station.nil?
           point = station.points.where(lantitude: lant, longitude: long).try(:first)
           if point.nil?
             station.points.create! lantitude: lant, longitude: long
           end
         end
       end
     end

   end
end
