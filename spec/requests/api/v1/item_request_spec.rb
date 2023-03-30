require 'rails_helper'

RSpec.describe "Item API" do

  describe "#index" do   
    it "can return all items" do
      create_list(:item, 3)
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
      create_list(:item, 3)
      
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

    it "can get the merchant data for a given item ID" do
      merchant = create(:merchant)
      item = create(:item, merchant_id: merchant.id)
  
      get "/api/v1/items/#{item.id}/merchant"
  
      expect(response).to be_successful
  
      parse = JSON.parse(response.body, symbolize_names: true)

      expect(parse[:data].size).to eq(3)
      expect(parse[:data]).to be_a Hash
      expect(parse[:data].keys).to eq([:id, :type, :attributes])
      expect(parse[:data][:id]).to eq(Merchant.first.id.to_s)
      expect(parse[:data][:type]).to eq("merchant")
      expect(parse[:data][:attributes]).to eq({name: Merchant.first.name})
    end

    it "should return 404" do
      merchant = create(:merchant)
      item = create(:item, merchant_id: merchant.id)
  
      get "/api/v1/items/abe/merchant"

      expect(response).to have_http_status(404)
      expect(JSON.parse(response.body)).to eq({"error"=>"Couldn't find Item with 'id'=abe"})
    end
  end

  describe "#create" do
    it "can create an item" do
      id = create(:merchant).id
      create_list(:item, 3)

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

    it "return an error if any attribute is missing" do
      id = create(:merchant).id
      create(:item)

      item_params = ({
        name: nil,
        description: 'Explanation for confusing Rails stuff',
        unit_price: 12345.99,
        merchant_id: id
      })

      headers = { "CONTENT_TYPE" => "application/json" } 

      post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

      expect(response).to_not be_successful
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body)).to eq({"error"=>"Invalid Create"})
    end
  end

  describe "#destroy" do
    it 'deletes the item' do
      item = create(:item)

      expect(Item.count).to eq(1)
     
      delete "/api/v1/items/#{item.id}"

      expect(response).to be_successful
      expect(Item.count).to eq(0)
      expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "#edit" do
    it "update an existing item" do
      merchant_id = create(:merchant).id
      item_id = create(:item).id

      previous_name = Item.last.name
      item_params = ({
        name: 'Magic',
        description: 'Explanation for confusing Rails stuff',
        unit_price: 12345.99,
        merchant_id: merchant_id
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/items/#{item_id}", headers: headers, params: JSON.generate({item: item_params})
      item = Item.find_by(id: item_id)

      expect(response).to be_successful
      expect(item.name).to_not eq(previous_name)
      expect(item.name).to eq("Magic")
    end

    it "can't update when id is invalid" do
      merchant_id = create(:merchant).id
      item_id = create(:item).id

      previous_name = Item.last.name
      item_params = ({
        name: 'Magic',
        description: 'Explanation for confusing Rails stuff',
        unit_price: 12345.99,
        merchant_id: merchant_id
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/items/adfewf", headers: headers, params: JSON.generate({item: item_params})
      item = Item.find_by(id: item_id)

      expect(response).to have_http_status(404)
      expect(JSON.parse(response.body)).to eq({"error"=>"Couldn't find Item with 'id'=adfewf"})
    end
  end
end