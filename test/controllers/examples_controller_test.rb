require 'test_helper'

class ExampleControllerTest < ActionDispatch::IntegrationTest
  test "should get view" do
    get example_view_url
    assert_response :success
  end

end
