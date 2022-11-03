module OmniauthMacros
  def mock_auth_hash(provider, email = nil)
    OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new(
      {
        'provider' => provider.to_s,
        'uid' => '123545',
        'info' => {
          'email' => email
        }
      }
    )
  end

  def invalid_mock_auth_hash(provider)
    OmniAuth.config.mock_auth[provider] = :invalid_credentials
  end
end
