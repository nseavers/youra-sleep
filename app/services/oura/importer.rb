module Oura
  class Importer
    def self.call!(user:, start_date:, end_date:)
      new(user:, start_date:, end_date:).call!
    end

    def initialize(user:, start_date:, end_date:)
      @user = user
      @start_date = start_date
      @end_date = end_date
    end

    # Oura API v2 usercollection endpoints that support start_date/end_date.
    # See https://cloud.ouraring.com/v2/docs
    COLLECTION_ENDPOINTS = [
      ["sleep", "/usercollection/sleep"],
      ["daily_sleep", "/usercollection/daily_sleep"],
      ["daily_activity", "/usercollection/daily_activity"],
      ["daily_readiness", "/usercollection/daily_readiness"],
      ["daily_resilience", "/usercollection/daily_resilience"],
      ["daily_spo2", "/usercollection/daily_spo2"],
      ["daily_stress", "/usercollection/daily_stress"],
      ["daily_cardiovascular_age", "/usercollection/daily_cardiovascular_age"],
      ["workout", "/usercollection/workout"],
      ["session", "/usercollection/session"],
      ["tag", "/usercollection/tag"],
      ["enhanced_tag", "/usercollection/enhanced_tag"],
      ["sleep_time", "/usercollection/sleep_time"],
      ["rest_mode_period", "/usercollection/rest_mode_period"],
      ["ring_configuration", "/usercollection/ring_configuration"],
      ["vo2_max", "/usercollection/vo2_max"],
    ].freeze

    def call!
      conn = @user.oura_connection
      raise "User has no Oura connection" if conn.nil?

      client = Oura::Client.new(access_token: conn.access_token)

      COLLECTION_ENDPOINTS.each do |data_type, path|
        pull_and_store(client, data_type, path)
      rescue StandardError => e
        # Skip endpoints that 403 (scope not granted) or fail; don't break the whole import
        Rails.logger.warn("[Oura::Importer] Skipped #{data_type}: #{e.message}")
      end
    end

    private

    def pull_and_store(client, data_type, path)
      payload = client.get(path, params: { start_date: @start_date.to_s, end_date: @end_date.to_s })

      OuraRawPayload.upsert(
        {
          user_id: @user.id,
          data_type: data_type,
          start_date: @start_date,
          end_date: @end_date,
          payload: payload,
          updated_at: Time.current,
          created_at: Time.current
        },
        unique_by: :index_oura_raw_range
      )
    end
  end
end