require "test_helper"

class CategoriesAttributesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @categories_attribute = categories_attributes(:one)
  end

  test "should get index" do
    get categories_attributes_url, as: :json
    assert_response :success
  end

  test "should create categories_attribute" do
    assert_difference("CategoriesAttribute.count") do
      post categories_attributes_url, params: { categories_attribute: {} }, as: :json
    end

    assert_response :created
  end

  test "should show categories_attribute" do
    get categories_attribute_url(@categories_attribute), as: :json
    assert_response :success
  end

  test "should update categories_attribute" do
    patch categories_attribute_url(@categories_attribute), params: { categories_attribute: {} }, as: :json
    assert_response :success
  end

  test "should destroy categories_attribute" do
    assert_difference("CategoriesAttribute.count", -1) do
      delete categories_attribute_url(@categories_attribute), as: :json
    end

    assert_response :no_content
  end
end
