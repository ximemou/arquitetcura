class RatesController < ApplicationController
  require 'base64'
  require 'rest-client'
  include RatesHelper

  def get_shipping_cost
    origin_latitude = params[:originLatitude]
    origin_longitude = params[:originLongitude]
    destination_latitude = params[:destinationLatitude]
    destination_longitude = params[:destinationLongitude]
    package_weight = params[:packageWeight]
    final_cost = 0
    is_estimated = false
    if(RatesHelper.no_cost_records)
      final_cost = RatesHelper.default_cost(package_weight)
      is_estimated_cost = true
    else
      cost_between_areas = RatesHelper.get_cost_from_records(origin_latitude, origin_longitude, destination_latitude, destination_longitude)
      cost_per_kg = RatesHelper.get_kg_price_from_record
      final_cost = (cost_per_kg.to_f* package_weight.to_f) +cost_between_areas.to_f
      is_estimated_cost = RatesHelper.cost_is_estimated
    end
    final_cost_as_json = "{ \"finalPrice\" : #{final_cost}, \"isEstimatedPrice\": #{is_estimated_cost}}"
      respond_to do |format|
        format.json{ render :json => final_cost_as_json}
      end
  end
end
