class CostJob < ApplicationJob
  queue_as :default

  def perform(*args)
    begin
    @user= '187086'
    @password= 'bToPPbQ3p9Vu'
    response= RestClient::Request.new(
        :method => :get,
        :url => "https://delivery-rates.mybluemix.net/areas",
        :user => @user,
        :password => @password,
        :headers =>  {:accept => 'application/json', :content_type => :json}
    ).execute
    areas=JSON.parse(response.to_str)
    response_kg= RestClient::Request.new(
        :method => :get,
        :url => "https://delivery-rates.mybluemix.net/cost",
        :user => @user,
        :password => @password,
        :headers =>  {:accept => 'application/json', :content_type => :json}

    ).execute
    results=JSON.parse(response_kg.to_str)
    cost_per_kg=results['cost']
    RatesHelper.save_record_values(areas, cost_per_kg)
    LogHelper.save_info_in_log("Se han actualizado los costos por area y el costo por kilo. Fecha y horario:  "+ Time.zone.now.to_s)
    UpdateShipmentCostNotifyUserJob.perform_now
    rescue RestClient::ServiceUnavailable
      LogHelper.save_info_in_log("No se pudo conectar con la api de costos. Error:503")
    end
  end
end