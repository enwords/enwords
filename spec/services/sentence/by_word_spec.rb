require 'rails_helper'

describe Sentence::ByWord do
  subject { described_class.run!(word: word, translation_lang: translation_lang) }

  let(:language) { 'eng' }
  let(:translation_lang) { 'rus' }
  let(:word_value) { 'word' }
  let(:translation_value) { 'слово' }

  let(:word) { create :word, value: word_value, language: language }
  let(:sentence) { create :sentence, value: 'word word word', language: language }
  let(:translation) { create :sentence, value: translation_value, language: translation_lang }
  let!(:link) { create :link, sentence: sentence, translation: translation }
  let!(:sentences_word) { create :sentences_word, sentence: sentence, word: word }
  let!(:mnemo) { create :mnemo, word: word }

  before do
    allow(API::Skyeng).to receive(:first_meaning).and_return(
      'id' => 92_160,
      'partOfSpeechCode' => 'n',
      'translation' => { 'text' => translation_value, 'note' => nil },
      'previewUrl' => '//static.skyeng.ru/image/download/project/dictionary/id/119873/width/96/height/72',
      'imageUrl' => '//static.skyeng.ru/image/download/project/dictionary/id/119873/width/640/height/480',
      'transcription' => 'wɜːd',
      'soundUrl' => '//dmsbj0x9fxpml.cloudfront.net/0795f8750310b61cf71bb9ff6fdc1d40.mp3',
      'text' => word_value
    )
  end

  it 'returns valid hash' do
    expect(subject).to eq(
      menemo: 'Контент',
      sentence: 'word word word',
      sentence_translation: 'слово',
      text: "*word* _[wɜːd]_ - слово\n\nword word word\n_слово_\n\n_Контент_",
      word: 'word',
      word_translation: 'слово'
    )
  end

  context 'rus -> eng' do
    let(:language) { 'rus' }
    let(:translation_lang) { 'eng' }
    let(:word_value) { 'слово' }
    let(:translation_value) { 'word' }

    before do
      allow(API::YandexTranslate).to receive(:translate).and_return(translation_value)
    end

    it 'returns valid hash' do
      expect(subject).to eq(
        menemo: 'Контент',
        sentence: 'word word word',
        sentence_translation: 'word',
        text: "*слово* - word\n\nword word word\n_word_\n\n_Контент_",
        word: 'слово',
        word_translation: 'word'
      )
    end
  end
end
