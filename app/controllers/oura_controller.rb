class OuraController < ApplicationController
  before_action :authenticate_user!

  AUTHORIZE_URL = "https://cloud.ouraring.com/oauth/authorize".freeze
  
  def connect
    state = SecureRandom.hex(24)
    session[:oura_oauth_state] = state

    redirect_uri = callback_redirect_uri

    query = {
      response_type: "code",
      client_id: ENV.fetch("OURA_CLIENT_ID"),
      redirect_uri: redirect_uri,
      scope: ENV.fetch("OURA_SCOPES"),
      state: state,
    }

    redirect_to "#{AUTHORIZE_URL}?#{query.to_query}", allow_other_host: true
  end

  def callback
    expected_state = session.delete(:oura_oauth_state).to_s
    received_state = params[:state].to_s

    unless expected_state.present? &&
           ActiveSupport::SecurityUtils.secure_compare(expected_state, received_state)
      raise ActionController::BadRequest, "Invalid OAuth state"
    end

    code = params[:code].to_s
    raise ActionController::BadRequest, "Missing code" if code.blank?

    token = Oura::OauthTokenExchange.call!(
      code: code,
      redirect_uri: callback_redirect_uri
    )

    conn = current_user.oura_connection || current_user.build_oura_connection
    conn.update!(
      access_token: token.fetch(:access_token),
      refresh_token: token.fetch(:refresh_token),
      expires_at: Time.current + token.fetch(:expires_in).to_i.seconds,
      scope: token[:scope]
    )

    # Phase 1: import immediately (or enqueue a job later)
    Oura::Importer.call!(user: current_user, start_date: Date.current - 7, end_date: Date.current)

    redirect_to oura_raw_payloads_path, notice: "Oura connected and data imported."
  end

  def disconnect
    current_user.oura_connection&.destroy
    redirect_to oura_raw_payloads_path, notice: "Oura disconnected."
  end

  private

  def callback_redirect_uri
    "#{ENV.fetch("OURA_REDIRECT_BASE_URL")}/oura/callback"
  end
end
