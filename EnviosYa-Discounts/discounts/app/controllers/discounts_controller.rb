class DiscountsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def create_discount
    receiver_email = params[:receiver_email]
    sender_email = params[:sender_email]
    Discount.create_discount(receiver_email, sender_email)
    LogHelper.saveInfoInLog("Se creo un descuento")
    resolve_format "{'status' : 'ok'}"
  end

  def get_discount
    discount = Discount.get_discount
    resolve_format discount
  end

  def has_discount
    user_email = params[:email]
    discount = Discount.has_discount(user_email)
    has_discount_to_return = {:has_discount => discount}
    resolve_format has_discount_to_return.to_json
  end

  def calculate_price_with_discount
    price_param = params[:price]
    price = Discount.calculate_price_with_discount(price_param.to_f)
    resolve_format price
  end

  def verify_discount
    user_email = params[:email]
    discount = Discount.verify_discount(user_email)
    has_discount_to_return = { :verify_discount => discount}
    resolve_format has_discount_to_return.to_json
  end

  private

  def resolve_format(obj)
    respond_to do |format|
      format.json { render :json => obj }
    end
  end
end
