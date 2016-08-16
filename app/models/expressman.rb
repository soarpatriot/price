class Expressman < ActiveRecord::Base
  belongs_to :station
  has_many :express_areas
  has_many :areas, through: :express_areas
  enum etype: [:no_syn,:syned ]
end
