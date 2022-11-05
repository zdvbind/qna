class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_url, alert: exception.message }
      format.js { render status: :forbidden }
      format.json { render json: exception.message, status: :forbidden }
    end
  end

  check_authorization unless: :devise_controller?

  before_action :gon_current_user

  private

  def gon_current_user
    gon.push({ current_user: current_user }) if signed_in?
  end
end
