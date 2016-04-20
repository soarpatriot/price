class Province < ActiveRecord::Base
  has_many :cities

  has_many :stations, through: :cities
  has_many :areas, through: :stations
  has_many :densities, through: :areas
end
