class Station < ActiveRecord::Base
  acts_as_xlsx

  has_many :points, as: :pointable, dependent: :destroy
  has_many :areas, dependent: :destroy

  has_many :densities, through: :areas
  belongs_to :stationable, polymorphic: true
  
end
