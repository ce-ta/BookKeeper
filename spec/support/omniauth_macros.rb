module OmniauthMacros
  def mock_auth_hash(provider: :github, uid: '123545', info: {})
    OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new(
      provider: provider.to_s,
      uid: uid,
      info: {
        name: info[:name] || 'Mock User',
        email: info[:email] || 'mockuser@example.com',
        image: info[:image] || 'mock_user_thumbnail_url'
      }
    )
  end
end