class Users::EmailsController < ApplicationController
  def new; end

  def create
    auth = OmniAuth::AuthHash.new(session[:auth])
    auth.info.email = email_params
    user = User.find_for_oauth(auth)

    if user&.persisted?
      user.confirmed_at = nil
      user.save!
      user.send_confirmation_instructions
      session[:auth] = nil
      redirect_to root_path, alert: 'Need email confirm'
    else
      render :new
    end
  end

  private

  def email_params
    params.require(:email)
  end
end
