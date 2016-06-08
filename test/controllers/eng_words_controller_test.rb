require 'test_helper'

class EngWordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @eng_word = eng_words(:one)
  end

  test "should get index" do
    get eng_words_url
    assert_response :success
  end

  test "should get new" do
    get new_eng_word_url
    assert_response :success
  end

  test "should create eng_word" do
    assert_difference('EngWord.count') do
      post eng_words_url, params: { eng_word: { id: @eng_word.id, word: @eng_word.word } }
    end

    assert_redirected_to eng_word_path(EngWord.last)
  end

  test "should show eng_word" do
    get eng_word_url(@eng_word)
    assert_response :success
  end

  test "should get edit" do
    get edit_eng_word_url(@eng_word)
    assert_response :success
  end

  test "should update eng_word" do
    patch eng_word_url(@eng_word), params: { eng_word: { id: @eng_word.id, word: @eng_word.word } }
    assert_redirected_to eng_word_path(@eng_word)
  end

  test "should destroy eng_word" do
    assert_difference('EngWord.count', -1) do
      delete eng_word_url(@eng_word)
    end

    assert_redirected_to eng_words_path
  end
end
