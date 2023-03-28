require 'rails_helper'

RSpec.describe "Item API" do
  before do
    create_list(:item, 3)
  end

  describe "#index" do
    it "can return all items" do
      get "/api/v1/items"

      expect(response).to be_successful

      parse = JSON.parse(response.body, symbolize_names: true)
      
      expect(parse[:data].size).to eq(3)
      expect(parse[:data]).to be_an Array
      expect(parse[:data][0].keys).to eq([:id, :type, :attributes])
      expect(parse[:data][0][:attributes][:name]).to eq(Item.first.name)
    end
  end

  describe "#show" do
    it "return one item" do
      item = Item.first

      get "/api/v1/items/#{item.id}"

      expect(response).to be_successful 
      
      parse = JSON.parse(response.body, symbolize_names: true)

      expect(parse[:data].keys).to eq([:id, :type, :attributes])
      expect(parse[:data][:attributes].size).to eq(4)
      expect(parse[:data][:id]).to eq(item.id.to_s)
      expect(parse[:data][:type]).to eq('item')
      expect(parse[:data][:attributes][:name]).to eq(item.name)
    end

    it "should return 404" do
      item = Item.first

      get "/api/v1/items/abc"

      expect(response).to have_http_status(404)
      expect(JSON.parse(response.body)).to eq({"error"=>"Couldn't find Item with 'id'=abc"})
    end
  end
end