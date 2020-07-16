class AdminsController < ApplicationController
  before_action :authenticate_admin!

  def acceptCadet
    cadet_id=params[:cadetId].to_i
    @token = params[:Authorization]
    AdminsHelper.confirmCadet(cadet_id, @token)
    flash[:notice] = 'El cadete ha sido confirmado'
    LogHelper.saveInfoInLog("Info: El cadete #{cadet_id} ha sido confirmado")
    redirect_to "/admins/index?Authorization=#{@token}"
  end

  def rejectCadet
    cadet_id=params[:cadetId].to_i
    @token = params[:Authorization]
    AdminsHelper.rejectCadet(cadet_id, @token)
    flash[:notice] = 'El cadete ha sido rechazado'
    LogHelper.saveInfoInLog("Info: El cadete #{cadet_id} ha sido rechazado")
    redirect_to "/admins/index?Authorization=#{@token}"
  end

  def showCadets
    @token = params[:Authorization]
    @cadets = AdminsHelper.getConfirmationPendingCadets(@token)
  end

  def delete_admin_session
    AdminsHelper.delete_session(current_admin.id)
    sign_out current_admin
    redirect_to ENV['MAIN_URL']
  end
end
