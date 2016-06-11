require 'test_helper'

class EngWordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    word = eng_words(:one)
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
      post eng_words_url, params: {word: {id: word.id, word: word.word } }
    end

    assert_redirected_to eng_word_path(Word.last)
  end

  test "should show eng_word" do
    get eng_word_url(word)
    assert_response :success
  end

  test "should get edit" do
    get edit_eng_word_url(word)
    assert_response :success
  end

  test "should update eng_word" do
    patch eng_word_url(word), params: {word: {id: word.id, word: word.word } }
    assert_redirected_to eng_word_path(word)
  end

  test "should destroy eng_word" do
    assert_difference('EngWord.count', -1) do
      delete eng_word_url(word)
    end

    assert_redirected_to eng_words_path
  end
end
