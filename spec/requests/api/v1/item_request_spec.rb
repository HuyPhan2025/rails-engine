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
end