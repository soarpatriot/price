class City < ActiveRecord::Base

  has_many :counties
  belongs_to :province
  has_many :stations, as: :stationable 

  has_many :areas, through: :stations
  has_many :densities, through: :areas

  has_many :districts
end
