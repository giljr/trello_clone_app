require "test_helper"

class BoardsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get boards_show_url
    assert_response :success
  end
end
