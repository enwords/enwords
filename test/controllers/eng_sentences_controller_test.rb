require 'test_helper'

class EngSentencesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @eng_sentence = eng_sentences(:one)
  end

  test "should get index" do
    get eng_sentences_url
    assert_response :success
  end

  test "should get new" do
    get new_eng_sentence_url
    assert_response :success
  end

  test "should create eng_sentence" do
    assert_difference('EngSentence.count') do
      post eng_sentences_url, params: { eng_sentence: { id: @eng_sentence.id, sentence: @eng_sentence.sentence } }
    end

    assert_redirected_to eng_sentence_path(EngSentence.last)
  end

  test "should show eng_sentence" do
    get eng_sentence_url(@eng_sentence)
    assert_response :success
  end

  test "should get edit" do
    get edit_eng_sentence_url(@eng_sentence)
    assert_response :success
  end

  test "should update eng_sentence" do
    patch eng_sentence_url(@eng_sentence), params: { eng_sentence: { id: @eng_sentence.id, sentence: @eng_sentence.sentence } }
    assert_redirected_to eng_sentence_path(@eng_sentence)
  end

  test "should destroy eng_sentence" do
    assert_difference('EngSentence.count', -1) do
      delete eng_sentence_url(@eng_sentence)
    end

    assert_redirected_to eng_sentences_path
  end
end
