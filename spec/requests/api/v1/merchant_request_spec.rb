require 'rails_helper'

RSpec.describe "Merchant API" do
  before do 
    create_list(:merchant, 3)
  end
  
  describe "#index" do
    it "can return all merchants" do
      get "/api/v1/merchants"

      expect(response).to be_successful 
      
      parse = JSON.parse(response.body, symbolize_names: true)

      expect(parse[:data].size).to eq(3)
      expect(parse[:data]).to be_an Array
      expect(parse[:data][0].keys).to eq([:id, :type, :attributes])
      expect(parse[:data][0][:attributes][:name]).to eq(Merchant.first.name)
    end  
  end

  describe "#show" do
    it "return one merchant" do
      @merchant = Merchant.first

      get "/api/v1/merchants/#{@merchant.id}"

      expect(response).to be_successful 

      parse = JSON.parse(response.body, symbolize_names: true)

      expect(parse[:data].keys).to eq([:id, :type, :attributes])
      expect(parse[:data][:attributes].size).to eq(1)
      expect(parse[:data][:id]).to eq(@merchant.id.to_s)
      expect(parse[:data][:type]).to eq('merchant')
      expect(parse[:data][:attributes][:name]).to eq(@merchant.name)
    end

    it "should return 404" do
      @merchant = Merchant.first

      get "/api/v1/merchants/abc"
      
      expect(response).to have_http_status(404)
      expect(JSON.parse(response.body)).to eq({"error"=>"Couldn't find Merchant with 'id'=abc"})
    end

    it "return all items from a given merchant ID" do
      merchant_id = create(:merchant).id

      create_list(:item, 3, merchant_id: merchant_id)

      get "/api/v1/merchants/#{merchant_id}/items"
      
      expect(response).to be_successful

      parse = JSON.parse(response.body, symbolize_names: true)
      
      expect(parse[:data].size).to eq(3)
      expect(parse[:data]).to be_an Array
      expect(parse[:data][0].keys).to eq([:id, :type, :attributes])
      expect(parse[:data][0][:id]).to eq(Item.first.id.to_s)
      expect(parse[:data][0][:type]).to eq("item")
      expect(parse[:data][0][:attributes].size).to eq(4)
      expect(parse[:data][0][:attributes].keys).to eq([:name, :description, :unit_price, :merchant_id])
      expect(parse[:data][0][:attributes][:name]).to eq(Item.first.name)
      expect(parse[:data][0][:attributes][:description]).to eq(Item.first.description)
      expect(parse[:data][0][:attributes][:unit_price]).to eq(Item.first.unit_price)
      expect(parse[:data][0][:attributes][:merchant_id]).to eq(Item.first.merchant_id)
    end

    it "should return 404" do
      merchant_id = create(:merchant).id

      create_list(:item, 3, merchant_id: merchant_id)

      get "/api/v1/merchants/abc/items"

      expect(response).to have_http_status(404)
      expect(JSON.parse(response.body)).to eq({"error"=>"Couldn't find Merchant with 'id'=abc"})
    end
  end
end