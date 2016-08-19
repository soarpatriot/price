class Expressman < ActiveRecord::Base
  belongs_to :station
  has_many :express_areas
  has_many :areas, through: :express_areas
  enum etype: [:no_syn,:syned,:imported ]

  scope :imported, -> {where etype: Expressman.etypes[:imported]}

  def self.save_xls_expressmen sheet
    sheet.each_with_index do  |row, i|
      if i >= 1
        if row 
          station_name = row.cells[0].try(:value)
          man_code = row.cells[1].try(:value)
          man_name = row.cells[2].try(:value)
          man_phone = row.cells[3].try(:value)
          
          station = Station.where(description: station_name.strip).first
          Expressman.create name: man_name, mobile: man_phone, code: man_code, station: station, etype: Expressman.etypes[:imported] 

        end
      end
    end

  end

  def self.check_xls sheet
      hash = Hash.new 
      tips = ""
      hash[:has_error] = false
      sheet.each_with_index do  |row, i|
        if i >= 1
          if row 
            station_name = row.cells[0].try(:value)
            man_code = row.cells[1].try(:value)
            man_name = row.cells[2].try(:value)
            man_phone = row.cells[3].try(:value)
            
            if station_name.nil? || man_code.nil? || man_phone.nil? || man_name.nil?
              hash[:has_error] = true
              tips = tips + "第 #{i+1} 行有空值，不符合要求! "
            else
              station = Station.where(description: station_name.strip).first
              if station.nil?
                hash[:has_error] = true
                tips = tips + "第 #{i+1} 行站点不存在，请检查站点名称! "
              else 

                expressman = Expressman.where(station_id: station.id, code: man_code.to_s.strip).first
                unless expressman.nil?

                  hash[:has_error] = true
                  tips = tips + "第 #{i+1} 行配送员已存在系统中, 请检查 "
                end
              end
 
            end 
          end
        end
      end
      hash[:tips] = tips
      hash
  end
end
