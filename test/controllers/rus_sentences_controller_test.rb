require 'test_helper'

class RusSentencesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @rus_sentence = rus_sentences(:one)
  end

  test "should get index" do
    get rus_sentences_url
    assert_response :success
  end

  test "should get new" do
    get new_rus_sentence_url
    assert_response :success
  end

  test "should create rus_sentence" do
    assert_difference('RusSentence.count') do
      post rus_sentences_url, params: { rus_sentence: { id: @rus_sentence.id, sentence: @rus_sentence.sentence } }
    end

    assert_redirected_to rus_sentence_path(RusSentence.last)
  end

  test "should show rus_sentence" do
    get rus_sentence_url(@rus_sentence)
    assert_response :success
  end

  test "should get edit" do
    get edit_rus_sentence_url(@rus_sentence)
    assert_response :success
  end

  test "should update rus_sentence" do
    patch rus_sentence_url(@rus_sentence), params: { rus_sentence: { id: @rus_sentence.id, sentence: @rus_sentence.sentence } }
    assert_redirected_to rus_sentence_path(@rus_sentence)
  end

  test "should destroy rus_sentence" do
    assert_difference('RusSentence.count', -1) do
      delete rus_sentence_url(@rus_sentence)
    end

    assert_redirected_to rus_sentences_path
  end
end
