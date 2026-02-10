module Oura
  class Client
    API_BASE = "https://api.ouraring.com/v2".freeze

    def initialize(access_token:)
      @access_token = access_token
    end

    def get(path, params: {})
      resp = Faraday.get("#{API_BASE}#{path}", params) do |req|
        req.headers["Authorization"] = "Bearer #{@access_token}"
      end

      json = JSON.parse(resp.body) rescue { "raw" => resp.body }

      raise "Oura API error (#{resp.status}): #{json}" unless resp.status.between?(200, 299)
      json
    end
  end
end