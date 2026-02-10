Rails.application.routes.draw do

  devise_for :users

  get "up" => "rails/health#show", as: :rails_health_check

  resource :oura, only: [], controller: "oura" do
    get :connect
    get :callback
    delete :disconnect
  end

  resources :oura_raw_payloads, only: [:index, :show]

  root "oura_raw_payloads#index"
end
