class Station < ActiveRecord::Base
  acts_as_xlsx

  has_many :points, as: :pointable, dependent: :destroy
  has_many :areas, ->{where atype: 0}, dependent: :destroy
  #has_many :commission_areas, ->{ where atype: 0},:source => :areas, dependent: :destroy
  has_many :delivery_areas, -> { where atype: 1  } , :class_name => 'Area', dependent: :destroy

  has_many :expressmen
  has_many :densities, through: :areas
  belongs_to :stationable, polymorphic: true
  
end
