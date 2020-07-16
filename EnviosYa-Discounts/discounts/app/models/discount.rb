class Discount < ApplicationRecord
  def self.create_discount(discount_receiver_email,discount_sender_email)
    Discount.create!(:discount_sender_email=> discount_sender_email, :discount_receiver_email=>discount_receiver_email,:receiver_made_shipment=>false)
  end

  def self.verify_discount(email)
    logged_user=email
    applies_discount_sender= Discount.where(["discount_sender_email= :email and receiver_made_shipment= :made_shipment",{email: logged_user, made_shipment: true}]).first()
    applies_discount_receiver=Discount.where(["discount_receiver_email= :email and receiver_made_shipment= :made_shipment",{email: logged_user, made_shipment: false}]).first()
    if(applies_discount_sender )
      Discount.delete(applies_discount_sender.id)
      return true
    elsif(applies_discount_receiver)
      applies_discount_receiver.receiver_made_shipment=true
      applies_discount_receiver.save!
      return true
    else
      return false
    end
  end

  def self.has_discount(email)
    logged_user=email
    applies_discount_sender= Discount.where(["discount_sender_email= :email and receiver_made_shipment= :made_shipment",{email: logged_user, made_shipment: true}]).first()
    applies_discount_receiver=Discount.where(["discount_receiver_email= :email and receiver_made_shipment= :made_shipment",{email: logged_user, made_shipment: false}]).first()
    if(applies_discount_receiver || applies_discount_sender)
      return true
    else
    return false
  end
end

  def self.calculate_price_with_discount(price)
    discount=get_discount;
    return price* ((100-discount)/100)
  end
  
  def self.get_discount
    return 50.0
  end
end