require 'test_helper'

class CategoryControllerTest < ActionDispatch::IntegrationTest
  test "should get name:string" do
    get category_name:string_url
    assert_response :success
  end

  test "should get color:string" do
    get category_color:string_url
    assert_response :success
  end

end
