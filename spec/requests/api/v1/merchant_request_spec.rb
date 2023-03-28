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

      expect(parse[:data].count).to eq(3)
      expect(parse[:data]).to be_an Array
      expect(parse[:data][0].keys).to eq([:id, :type, :attributes])
      expect(parse[:data][0][:attributes][:name]).to eq(Merchant.first.name)
    end
  end
end