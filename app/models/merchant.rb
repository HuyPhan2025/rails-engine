class Merchant < ApplicationRecord
  validates_presence_of :name 

  has_many :items
  has_many :invoices

  def self.search_merchant(word)
    where("name ILIKE ?", "%#{word}%").order(:name).first
  end
end
