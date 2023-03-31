class Item < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :unit_price
  validates_numericality_of :unit_price

  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  def destroy_association
    invoices.each do |invoice|
      invoice.destroy if invoice.items.size == 1
    end
  end

  def self.search_items(word)
    where("name ILIKE ?", "%#{word}%").order(:name)
  end

  def self.find_items_by_min_price(min_price)
    where("unit_price >= ?", min_price).order(:unit_price)
  end

  def self.find_items_by_max_price(max_price)
    where("unit_price <= ?", max_price).order(:unit_price)
  end

  def self.find_items_betwee_min_and_max_price(min_price, max_price)
    where("unit_price >= :min AND unit_price <= :max", { min: min_price, max: max_price }).order(:unit_price)
    # where("items.unit_price > ?", min_price).where("items.unit_price < ?", max_price).order(:unit_price)
  end


end
