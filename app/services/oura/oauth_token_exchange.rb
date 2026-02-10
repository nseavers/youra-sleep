module Oura
  class OauthTokenExchange
    TOKEN_URL = "https://api.ouraring.com/oauth/token".freeze

    def self.call!(code:, redirect_uri:)
      new(code:, redirect_uri:).call!
    end

    def initialize(code:, redirect_uri:)
      @code = code
      @redirect_uri = redirect_uri
    end

    def call!
      resp = ::Faraday.post(TOKEN_URL) do |req|
        req.headers["Content-Type"] = "application/x-www-form-urlencoded"
        req.body = {
          grant_type: "authorization_code",
          code: @code,
          redirect_uri: @redirect_uri,
          client_id: ENV.fetch("OURA_CLIENT_ID"),
          client_secret: ENV.fetch("OURA_CLIENT_SECRET")
        }
      end

      json = JSON.parse(resp.body)
      raise "Token exchange failed (#{resp.status}): #{json}" unless resp.status.between?(200, 299)

      {
        access_token: json.fetch("access_token"),
        refresh_token: json["refresh_token"],
        expires_in: json.fetch("expires_in"),
        scope: json["scope"]
      }
    end
  end
end