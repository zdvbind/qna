class FindForOauth
  attr_reader :auth

  def initialize(auth)
    @auth = auth
  end

  def call
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    return find_or_create_user_with_email if auth.info.email

    User.new
  end

  def find_or_create_user_with_email
    email = auth.info.email
    user = User.find_by(email: email)

    unless user
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password)
      user.confirm
      user.create_authorization(auth)
      return user
    end

    user.create_authorization(auth)
    user
  end
end
