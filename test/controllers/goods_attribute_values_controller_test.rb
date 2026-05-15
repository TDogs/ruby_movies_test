require "test_helper"

class GoodsAttributeValuesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @goods_attribute_value = goods_attribute_values(:one)
  end

  test "should get index" do
    get goods_attribute_values_url, as: :json
    assert_response :success
  end

  test "should create goods_attribute_value" do
    assert_difference("GoodsAttributeValue.count") do
      post goods_attribute_values_url, params: { goods_attribute_value: {} }, as: :json
    end

    assert_response :created
  end

  test "should show goods_attribute_value" do
    get goods_attribute_value_url(@goods_attribute_value), as: :json
    assert_response :success
  end

  test "should update goods_attribute_value" do
    patch goods_attribute_value_url(@goods_attribute_value), params: { goods_attribute_value: {} }, as: :json
    assert_response :success
  end

  test "should destroy goods_attribute_value" do
    assert_difference("GoodsAttributeValue.count", -1) do
      delete goods_attribute_value_url(@goods_attribute_value), as: :json
    end

    assert_response :no_content
  end
end
