require 'rails_helper'

describe Sentence::ByWord do
  subject do
    described_class.run!(
      word:       word,
      trans_lang: trans_lang
    )
  end

  let(:language) { 'rus' }

  let(:trans_lang) { 'eng' }

  let(:word) do
    create :word, word: 'Привет', language: language
  end

  let(:sentence) do
    create :sentence, sentence: 'Reply to answer', language: language
  end

  let(:translation) do
    create :sentence, sentence: 'Ответ на привет', language: trans_lang
  end

  let!(:link) do
    create :link, sentence: sentence, translation: translation
  end

  let!(:sentences_word) do
    create :sentences_word, sentence: sentence, word: word
  end

  let!(:mnemo) do
    create :mnemo, word: word
  end

  it do
    expect(subject.sentence).to eq('Reply to answer')
    expect(subject.translation).to eq('Ответ на привет')
    expect(subject.text).to eq("Reply to answer\n* * *\nОтвет на привет\n* * *\nКонтент\n")
  end
end
