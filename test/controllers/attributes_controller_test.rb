require "test_helper"

class AttributesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @attribute = attributes(:one)
  end

  test "should get index" do
    get attributes_url, as: :json
    assert_response :success
  end

  test "should create attribute" do
    assert_difference("Attribute.count") do
      post attributes_url, params: { attribute: {} }, as: :json
    end

    assert_response :created
  end

  test "should show attribute" do
    get attribute_url(@attribute), as: :json
    assert_response :success
  end

  test "should update attribute" do
    patch attribute_url(@attribute), params: { attribute: {} }, as: :json
    assert_response :success
  end

  test "should destroy attribute" do
    assert_difference("Attribute.count", -1) do
      delete attribute_url(@attribute), as: :json
    end

    assert_response :no_content
  end
end
