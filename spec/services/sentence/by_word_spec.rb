require 'rails_helper'

describe Sentence::ByWord do
  subject { described_class.run!(word: word, trans_lang: trans_lang) }

  before do
    allow(Api::Skyeng).to receive(:first_meaning).and_return(
      'id' => 92_160,
      'partOfSpeechCode' => 'n',
      'translation' => { 'text' => 'слово', 'note' => nil },
      'previewUrl' => '//static.skyeng.ru/image/download/project/dictionary/id/119873/width/96/height/72',
      'imageUrl' => '//static.skyeng.ru/image/download/project/dictionary/id/119873/width/640/height/480',
      'transcription' => 'wɜːd',
      'soundUrl' => '//dmsbj0x9fxpml.cloudfront.net/0795f8750310b61cf71bb9ff6fdc1d40.mp3',
      'text' => 'word'
    )
  end

  let(:language) { 'rus' }
  let(:trans_lang) { 'eng' }

  let(:word) do
    create :word, value: 'word', language: language
  end

  let(:sentence) do
    create :sentence, value: 'word word word', language: language
  end

  let(:translation) do
    create :sentence, value: 'слово', language: trans_lang
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
end
