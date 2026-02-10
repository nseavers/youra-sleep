class OuraRawPayloadsController < ApplicationController
  before_action :authenticate_user!

  def index
    @payloads = current_user.oura_raw_payloads.order(created_at: :desc)
  end

  def show
    @payload = current_user.oura_raw_payloads.find(params[:id])
  end
end
