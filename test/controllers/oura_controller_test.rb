require "test_helper"

class OuraControllerTest < ActionDispatch::IntegrationTest
  test "should get connect" do
    get oura_connect_url
    assert_response :success
  end

  test "should get callback" do
    get oura_callback_url
    assert_response :success
  end
end
