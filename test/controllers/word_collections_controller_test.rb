require 'test_helper'

class WordCollectionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @word_collection = word_collections(:one)
  end

  test "should get index" do
    get word_collections_url
    assert_response :success
  end

  test "should get new" do
    get new_word_collection_url
    assert_response :success
  end

  test "should create word_collection" do
    assert_difference('WordCollection.count') do
      post word_collections_url, params: { word_collection: { user_id: @word_collection.user_id } }
    end

    assert_redirected_to word_collection_path(WordCollection.last)
  end

  test "should show word_collection" do
    get word_collection_url(@word_collection)
    assert_response :success
  end

  test "should get edit" do
    get edit_word_collection_url(@word_collection)
    assert_response :success
  end

  test "should update word_collection" do
    patch word_collection_url(@word_collection), params: { word_collection: { user_id: @word_collection.user_id } }
    assert_redirected_to word_collection_path(@word_collection)
  end

  test "should destroy word_collection" do
    assert_difference('WordCollection.count', -1) do
      delete word_collection_url(@word_collection)
    end

    assert_redirected_to word_collections_path
  end
end
