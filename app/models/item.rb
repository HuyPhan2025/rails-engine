class Item < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :unit_price
  validates_numericality_of :unit_price

  belongs_to :merchant
end
