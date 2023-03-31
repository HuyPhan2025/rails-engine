class Api::V1::Items::SearchController < ApplicationController
  def index
    if params[:name] && params[:min_price] && params[:max_price]
      render json: { errors: "Can't search by name and price" }, status: 400
 
    elsif params[:name] && !params[:min_price] && !params[:max_price]
      items = Item.search_items(params[:name])
      render json: ItemSerializer.new(items)
 
    elsif params[:min_price] && params[:max_price] && !params[:name]
      if params[:min_price].to_i >= 0 && params[:max_price].to_i >= 0
        items_between_prices = Item.find_items_betwee_min_and_max_price(params[:min_price], params[:max_price])
        render json: ItemSerializer.new(items_between_prices)
      else
        render json: { errors: "Price must be greater than 0" }, status: 400
      end
 
    elsif params[:min_price] && !params[:name] && !params[:max_price]
      if params[:min_price].to_i >= 0 
        items_over_min_price = Item.find_items_by_min_price(params[:min_price])
        render json: ItemSerializer.new(items_over_min_price)
      else
        render json: { errors: "Price must be greater than 0" }, status: 400
      end
     
    elsif params[:max_price] && !params[:name] && !params[:min_price]
      if params[:max_price].to_i >= 0
        items_under_max_price = Item.find_items_by_max_price(params[:max_price])
        render json: ItemSerializer.new(items_under_max_price)
      else
        render json: { errors: "Price must be greater than 0" }, status: 400
      end

    else
      render json: { errors: "Missing Parameters" }, status: 400
    end
  end
end
