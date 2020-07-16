module RatesHelper
  def self.get_area_id(areas, latitude, longitude)
    areas.each do |a|
      poly_text=a['polygon']
      if (is_in_polygon(poly_text, latitude, longitude))
        return a['id']
      end
    end
  end


  def self.get_price_between_areas(areas, origin_area_id, destination_area_id)
    if origin_area_id== destination_area_id
      return 0
    else
      areas.each do |a|
        if (a['id']==origin_area_id)
          return a['costToAreas'][destination_area_id.to_s]
        end
      end
    end
  end


  def self.get_cost_from_records(origin_latitude, origin_longitude, destination_latitude, destination_longitude)

    three_last_costs=0
    final_cost=0
    last_area = (last_record)['area']
    last_time = (last_record)['created_at']
    areas_record = Record.pluck(:area)
    id_origin_area= RatesHelper.get_area_id(last_area, origin_latitude, origin_longitude)
    id_destination_area=RatesHelper.get_area_id(last_area, destination_latitude, destination_longitude)
    if (TimeDifference.between(Time.zone.now, last_time).in_minutes>10)
      areas_record.each do |record|
        cost_between_areas= RatesHelper.get_price_between_areas(record, id_origin_area, id_destination_area)
        three_last_costs += cost_between_areas
      end
      final_cost=three_last_costs/(areas_record.length)
    else
      final_cost= RatesHelper.get_price_between_areas(last_area, id_origin_area, id_destination_area)
    end
    return final_cost
  end

  def self.cost_is_estimated
    is_estimated=false
    last_time = (last_record)['created_at']
    if (TimeDifference.between(Time.zone.now, last_time).in_minutes>10)
      isEstimated=true
    else
      return is_estimated
    end

  end

  def self.get_kg_price_from_record
    three_last_kg_price=0
    final_kg=0
    last_time = (last_record)['created_at']
    last_kg_record = (last_record)['kgCost']
    kg_record = Record.pluck(:kgCost)
    if (TimeDifference.between(Time.zone.now, last_time).in_minutes>10)
      kg_record.each do |price|
        three_last_kg_price += price.to_i
        final_kg=three_last_kg_price/(kg_record.length)
      end
    else
      final_kg= last_kg_record.to_f
    end
    return final_kg
  end

  def self.no_cost_records
    no_cost=false
    records_length = Record.all.length
    if (records_length==0)
      no_cost=true
    end
    return no_cost
  end

  def self.default_cost(package_weight)
    price=(package_weight.to_f*100)
    return price.to_f
  end

  def self.save_record_values(areas, kg_price)
    if (Record.all.length == 3)
      Record.destroy(min_record_id)
    end
    Record.create!(:area => areas, :kgCost => kg_price)
  end

  def self.calculate_final_cost_when_api_working(shipment)
    puts 'entro al calculateFinalCostWhenApiWorking'
    last_area = (last_record)['area']
    last_kg_record = (last_record)['kgCost']
    id_origin_area= RatesHelper.get_area_id(last_area, shipment.origin_latitude, shipment.origin_longitude)
    id_destination_area=RatesHelper.get_area_id(last_area, shipment.destination_latitude, shipment.destination_longitude)
    final_cost_per_area= RatesHelper.get_price_between_areas(last_area, id_origin_area, id_destination_area)
    price_per_kg= last_kg_record.to_f
    LogHelper.save_info_in_log("Se han actualizado los costos por area y el costo por kilo. Fecha y horario:  "+ Time.zone.now.to_s)
    final_cost= (shipment.package_weight * price_per_kg)+final_cost_per_area
    return final_cost
  end

  private
  def self.is_in_polygon(poly_text, latitude, longitude)
    points = []
    start_pos =10
    final_pos = poly_text.length - 3
    cutted_poly_str = poly_text[start_pos..final_pos] #puts "-34.8928128641208630 -56.3013267517089844, ..., -34.8928128641208630 -56.3013267517089844"
    splitted_coordinates = cutted_poly_str.split(', ') #puts ["-34.8928128641208630 -56.3013267517089844", ..., "-34.8928128641208630 -56.3013267517089844"]
    splitted_coordinates.each do |c|
      lat = c.split(' ')[0] #inside "-34.8928128641208630 -56.3013267517089844" puts "-34.8928128641208630"
      lng = c.split(' ')[1] #inside "-34.8928128641208630 -56.3013267517089844" puts "-56.3013267517089844"
      points << Geokit::LatLng.new(lat, lng) #fill with LatLng object type
    end
    arr_polygon = Geokit::Polygon.new(points) #create the polygon from the array
    if arr_polygon.contains? Geokit::LatLng.new(latitude, longitude) #check whether point is within the polygon, should return true
      return true
    else
      return false
    end
  end

  def self.last_record
    records = Record.all
    max_id = records[0].id
    records.each do |r|
      if (r.id > max_id)
        max_id = r.id
      end
    end
    last_record_obj = Record.find(max_id)
    return last_record_obj
  end

  def self.min_record_id
    records = Record.all
    min_id = records[0].id
    records.each do |r|
      if (r.id < min_id)
        min_id = r.id
      end
    end
    return min_id
  end
end