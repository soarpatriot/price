class Expressman < ActiveRecord::Base
  has_many :express_areas
  has_many :areas, through: :express_areas
end
