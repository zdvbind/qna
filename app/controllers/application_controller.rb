class ApplicationController < ActionController::Base
  before_action :gon_current_user

  private

  def gon_current_user
    gon.push({current_user: current_user}) if signed_in?
  end
end
