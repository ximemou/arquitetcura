class Cadet < ApplicationRecord
  devise :database_authenticatable, :rememberable, :trackable
  mount_uploader :vehicle_information, AttachmentUploader
  mount_uploader :profile_image, ImageUploader
  mount_uploader :driver_license_image, ImageUploader

  def self.get_near_cadets(origin_latitude,origin_longitude)
    cadets = where(pending: false)
    distances = Hash.new
    cadets.each do |i|
      distance = get_distance_between_two_points(origin_latitude, origin_longitude, i.latitude, i.longitude)
      distances[i.email]=distance
    end
    distances = distances.sort_by{|key, value| value }
    cadets_to_return = []
    count = 0
    distances.each  do |j,k|
      if distances.length <= 4 || (distances.length > 4 && count < 4)
        cadets_to_return.push(find_by_email(j))
        count = count + 1
      end
    end
    cadets_to_return
    end

  def self.get_cadet_by_id(id)
    return find(id)
  end

  def self.update_location(cadet_id, latitude, longitude)
    cadet = find(cadet_id)
    cadet.latitude = latitude
    cadet.longitude = longitude
    cadet.save!
  end

  def self.convert_cadet_to_send_email(cadet)
    cadet_to_return= new(:id=> cadet.id, :name=> cadet.name,:lastname=> cadet.lastname)
    return cadet_to_return
  end

  def self.get_confirmation_pending_cadets
    cadets = where(pending:true)
    return cadets
  end

  def self.confirm_cadet(cadet_id)
    cadet = find(cadet_id)
    cadet.pending = false
    cadet.save!
    CadetsHelper.send_status_notification(cadet.email, true)
  end

  def self.reject_cadet(cadet_id)
    cadet=find(cadet_id)
    cadet.destroy
    CadetsHelper.send_status_notification(cadet.email,false)
  end

 private

  def self.get_distance_between_two_points(origin_latitude, origin_longitude, cadet_latitude, cadet_longitude)
    rad_per_deg=Math::PI/180
    rkm=6371
    rm=rkm*1000
    dlat_rad=(cadet_latitude.to_f-origin_latitude.to_f)*rad_per_deg
    dlon_rad=(cadet_longitude.to_f-origin_longitude.to_f)*rad_per_deg
    lat_cadet_origin=cadet_latitude.to_f*rad_per_deg
    lon_cadet_origin=cadet_longitude.to_f*rad_per_deg
    lat_origin=origin_latitude.to_f*rad_per_deg
    lon_origin=origin_longitude.to_f*rad_per_deg
    a=Math.sin(dlat_rad/2)**2+Math.cos(lat_cadet_origin)*Math.cos(lat_origin)*Math.sin(dlon_rad/2)**2
    c= 2* Math::atan2(Math::sqrt(a),Math::sqrt(1-a))
    rm*c
  end

end