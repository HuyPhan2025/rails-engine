require 'rails_helper'

RSpec.describe "Merchant API" do
  before do 
    create_list(:merchant, 3)
    # create_list(:item, 5)
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

    it "should not return 404" do
      @merchant = Merchant.first

      get "/api/v1/merchants/abc"
      
      expect(response).to have_http_status(404)
      expect(JSON.parse(response.body)).to eq({"error"=>"Couldn't find Merchant with 'id'=abc"})
    end
  end
end