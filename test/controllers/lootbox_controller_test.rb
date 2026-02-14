require "test_helper"

class LootboxControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get lootbox_index_url
    assert_response :success
  end
end
