class Commission < ActiveRecord::Base
  validates :name,:price  ,presence: true
  validates :name, uniqueness: true 
  has_many :areas
end
