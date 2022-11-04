class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    oauth_cb('github')
  end

  def vkontakte
    oauth_cb('vkontakte')
  end

  private

  def oauth_cb(provider)
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    elsif @user && @user.email.empty?
      session[:auth] = request.env['omniauth.auth']
      redirect_to new_users_email_path, alert: 'Need your email'
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end
end
