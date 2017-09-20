require 'test_helper'

class AuthorsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get authors_index_url
    assert_response :success
  end

  test "should get show" do
    get authors_show_url
    assert_response :success
  end

  test "should get create" do
    get authors_create_url
    assert_response :success
  end

  test "should get edit" do
    get authors_edit_url
    assert_response :success
  end

  test "should get delete" do
    get authors_delete_url
    assert_response :success
  end

end
