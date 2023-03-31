require "rails_helper"

RSpec.describe "Merchant Items Search API" do
  describe "#index" do
    it "should return all" do
      merchant = create(:merchant)
      item1 = create(:item, name: "Basketball", unit_price: 3.25, merchant_id: merchant.id)
      item2 = create(:item, name: "Baseball", unit_price: 30.00, merchant_id: merchant.id)
      item3 = create(:item, name: "Beachball", unit_price: 5.99, merchant_id: merchant.id)
      item4 = create(:item, name: "Bowlingball", unit_price: 15.00, merchant_id: merchant.id)

      get "/api/v1/items/find_all?name=bas"

      expect(response).to be_successful
      parse = JSON.parse(response.body, symbolize_names: true)
 
      expect(parse[:data].size).to eq(2)
      expect(parse[:data]).to be_an Array
      expect(parse[:data][0].keys).to eq([:id, :type, :attributes])
      expect(parse[:data][0][:attributes][:name]).to eq(item2.name)
      expect(parse[:data][1][:attributes][:name]).to eq(item1.name)
    end

    it "should return the empty array when no item is found with the given search" do
      merchant = create(:merchant)
      item1 = create(:item, name: "Basketball", unit_price: 3.25, merchant_id: merchant.id)
      item2 = create(:item, name: "Baseball", unit_price: 30.00, merchant_id: merchant.id)
      item3 = create(:item, name: "Beachball", unit_price: 5.99, merchant_id: merchant.id)
      item4 = create(:item, name: "Bowlingball", unit_price: 15.00, merchant_id: merchant.id)

      get "/api/v1/items/find_all?name=abc"

      expect(response).to be_successful
      parse = JSON.parse(response.body, symbolize_names: true)

      expect(parse).to be_a(Hash)
      expect(parse.keys).to eq([:data])
      expect(parse[:data]).to eq([])
    end


   it "should return all items greater than or equal to Min price" do
      merchant = create(:merchant)
      item1 = create(:item, name: "Basketball", unit_price: 3.25, merchant_id: merchant.id)
      item2 = create(:item, name: "Baseball", unit_price: 30.00, merchant_id: merchant.id)
      item3 = create(:item, name: "Beachball", unit_price: 5.99, merchant_id: merchant.id)
      item4 = create(:item, name: "Bowlingball", unit_price: 15.00, merchant_id: merchant.id)

      get "/api/v1/items/find_all?min_price=3.25"

      expect(response).to be_successful
      parse = JSON.parse(response.body, symbolize_names: true)
    
      expect(parse.keys).to eq([:data])
      expect(parse[:data]).to be_an(Array)
      expect(parse[:data].size).to eq(4)
      expect(parse[:data][0][:attributes].keys).to eq([:name, :description, :unit_price, :merchant_id])
      expect(parse[:data][0][:attributes][:name]).to eq(Item.first.name)
      expect(parse[:data][0][:attributes][:description]).to eq(Item.first.description)
      expect(parse[:data][0][:attributes][:unit_price]).to eq(Item.first.unit_price)
      expect(parse[:data][0][:attributes][:merchant_id]).to eq(Item.first.merchant_id)
    end

   it "should return all items less than or equal to Max price" do
      merchant = create(:merchant)
      item1 = create(:item, name: "Basketball", unit_price: 3.25, merchant_id: merchant.id)
      item2 = create(:item, name: "Baseball", unit_price: 30.00, merchant_id: merchant.id)
      item3 = create(:item, name: "Beachball", unit_price: 5.99, merchant_id: merchant.id)
      item4 = create(:item, name: "Bowlingball", unit_price: 15.00, merchant_id: merchant.id)

      get "/api/v1/items/find_all?max_price=30.00"
      parse = JSON.parse(response.body, symbolize_names: true)
      
      expect(parse.keys).to eq([:data])
      expect(parse[:data]).to be_an(Array)
      expect(parse[:data].size).to eq(4)
      expect(parse[:data][0][:attributes].keys).to eq([:name, :description, :unit_price, :merchant_id])
      expect(parse[:data][0][:attributes][:name]).to eq(Item.first.name)
      expect(parse[:data][0][:attributes][:description]).to eq(Item.first.description)
      expect(parse[:data][0][:attributes][:unit_price]).to eq(Item.first.unit_price)
      expect(parse[:data][0][:attributes][:merchant_id]).to eq(Item.first.merchant_id)
   end

   it "should return all items between a given min and max price" do
    merchant = create(:merchant)
      item1 = create(:item, name: "Basketball", unit_price: 3.25, merchant_id: merchant.id)
      item2 = create(:item, name: "Baseball", unit_price: 30.00, merchant_id: merchant.id)
      item3 = create(:item, name: "Beachball", unit_price: 5.99, merchant_id: merchant.id)
      item4 = create(:item, name: "Bowlingball", unit_price: 15.00, merchant_id: merchant.id)
      
      get "/api/v1/items/find_all?max_price=28.75&min_price=3.25"
      parse = JSON.parse(response.body, symbolize_names: true)

      expect(parse.keys).to eq([:data])
      expect(parse[:data]).to be_an(Array)
      expect(parse[:data].size).to eq(3)
      expect(parse[:data][0][:attributes].keys).to eq([:name, :description, :unit_price, :merchant_id])
      expect(parse[:data][0][:attributes][:name]).to eq(Item.first.name)
      expect(parse[:data][0][:attributes][:description]).to eq(Item.first.description)
      expect(parse[:data][0][:attributes][:unit_price]).to eq(Item.first.unit_price)
      expect(parse[:data][0][:attributes][:merchant_id]).to eq(Item.first.merchant_id)
   end

  end
end