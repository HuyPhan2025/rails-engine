require "rails_helper"

RSpec.describe "Merchants Search API" do
  describe "#show" do
    it "find a single merchant which matches a search term" do
      merchant1 = create(:merchant, name: "Christy")
      merchant2 = create(:merchant, name: "Christine")
      merchant3 = create(:merchant, name: "Sue")

      get "/api/v1/merchants/find?name=chr"

      expect(response).to be_successful
      parse = JSON.parse(response.body, symbolize_names: true)

      expect(parse[:data].keys).to eq([:id, :type, :attributes])
      expect(parse[:data][:attributes].size).to eq(1)
      expect(parse[:data][:id]).to eq(merchant2.id.to_s)
      expect(parse[:data][:type]).to eq('merchant')
      expect(parse[:data][:attributes][:name]).to eq(merchant2.name)
      expect(parse[:data][:attributes][:name]).to_not eq(merchant1.name)
      expect(parse[:data][:attributes][:name]).to_not eq(merchant3.name)
    end

    it "should return an empty hash when no merchant is found with the given search" do
      merchant1 = create(:merchant, name: "Christy")
      merchant2 = create(:merchant, name: "Christine")
      merchant3 = create(:merchant, name: "Sue")

      get "/api/v1/merchants/find?name=abc"

      expect(response).to be_successful
      parse = JSON.parse(response.body, symbolize_names: true)

      expect(parse).to be_a(Hash)
      expect(parse.keys).to eq([:data])
      expect(parse[:data]).to eq({})
    end
  end
end