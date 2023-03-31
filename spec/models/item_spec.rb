require 'rails_helper'

RSpec.describe Item, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :unit_price }
    it { should validate_numericality_of :unit_price }
  end

  describe "relationships" do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  describe "destroy associations" do
    before do
      @merchant = create(:merchant)

      @item1 = create(:item, merchant: @merchant)
      @item2 = create(:item, merchant: @merchant)
      @item3 = create(:item, merchant: @merchant)

      @customer1 = create(:customer)

      @invoice1 = create(:invoice, merchant: @merchant, customer: @customer1)
      @invoice2 = create(:invoice, merchant: @merchant, customer: @customer1)

      create(:invoice_item, item: @item1, invoice: @invoice1)
      create(:invoice_item, item: @item2, invoice: @invoice2)
      create(:invoice_item, item: @item3, invoice: @invoice2)

      create(:transaction, invoice:@invoice1)
      create(:transaction, invoice:@invoice2)
    end

    it "destroy associations" do
      expect(Invoice.all.to_a).to eq([@invoice1, @invoice2])
      expect(InvoiceItem.all.size).to eq(3)
      expect(Transaction.all.size).to eq(2)

      @item1.destroy_association

      expect(Invoice.all.to_a).to eq([@invoice2])
      expect(InvoiceItem.all.size).to eq(2)
      expect(Transaction.all.size).to eq(1)
    end
  end

  describe "#class methods" do
    it "should return all item matches search term and order alphabetically" do
      merchant = create(:merchant)
      item1 = create(:item, name: "Basketball", unit_price: 3.25, merchant_id: merchant.id)
      item2 = create(:item, name: "Baseball", unit_price: 30.00, merchant_id: merchant.id)
      item3 = create(:item, name: "Beachball", unit_price: 5.99, merchant_id: merchant.id)
      item4 = create(:item, name: "Bowlingball", unit_price: 15.00, merchant_id: merchant.id)

      expect(Item.search_items("bas")).to eq([item2, item1])
    end

    it "should return the items at min price" do
      merchant = create(:merchant)
      item1 = create(:item, name: "Basketball", unit_price: 3.25, merchant_id: merchant.id)
      item2 = create(:item, name: "Baseball", unit_price: 30.00, merchant_id: merchant.id)
      item3 = create(:item, name: "Beachball", unit_price: 5.99, merchant_id: merchant.id)
      item4 = create(:item, name: "Bowlingball", unit_price: 15.00, merchant_id: merchant.id)

      expect(Item.find_items_by_min_price(10)).to eq([item4, item2])
    end

    it "should return the items at max price" do
      merchant = create(:merchant)
      item1 = create(:item, name: "Basketball", unit_price: 3.25, merchant_id: merchant.id)
      item2 = create(:item, name: "Baseball", unit_price: 30.00, merchant_id: merchant.id)
      item3 = create(:item, name: "Beachball", unit_price: 5.99, merchant_id: merchant.id)
      item4 = create(:item, name: "Bowlingball", unit_price: 15.00, merchant_id: merchant.id)

      expect(Item.find_items_by_max_price(10)).to eq([item1, item3])
    end

    it "should return the items between the min/max price" do
      merchant = create(:merchant)
      item1 = create(:item, name: "Basketball", unit_price: 3.25, merchant_id: merchant.id)
      item2 = create(:item, name: "Baseball", unit_price: 30.00, merchant_id: merchant.id)
      item3 = create(:item, name: "Beachball", unit_price: 5.99, merchant_id: merchant.id)
      item4 = create(:item, name: "Bowlingball", unit_price: 15.00, merchant_id: merchant.id)

      expect(Item.find_items_betwee_min_and_max_price(5.00, 50.00)).to eq([item3, item4, item2])
      expect(Item.find_items_betwee_min_and_max_price(0.00, 10.00)).to eq([item1, item3])
      expect(Item.find_items_betwee_min_and_max_price(0.00, 5.00)).to eq([item1])
    end
  end
end
