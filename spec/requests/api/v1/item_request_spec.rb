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

  describe "#create" do
    it "can create an item" do
      id = create(:merchant).id

      item_params = ({
                      name: 'Magic',
                      description: 'Explanation for confusing Rails stuff',
                      unit_price: 12345.99,
                      merchant_id: id
                    })

      headers = { "CONTENT_TYPE" => "application/json" }          

      post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

      created_item = Item.last

      expect(response).to be_successful
      expect(response).to have_http_status(201)
      expect(created_item.name).to eq(item_params[:name])
      expect(created_item.description).to eq(item_params[:description])
      expect(created_item.unit_price).to eq(item_params[:unit_price])
      expect(created_item.merchant_id).to eq(item_params[:merchant_id])
    end
  end

  # describe "#destroy" do
  #   expect(Item.count).to eq(3)

  #   delete "/api/v1/items/#{item.id}"

  #   expect(response).to be_successful
  #   expect(Item.count).to eq(2)

  # end
end