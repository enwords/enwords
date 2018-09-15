require 'rails_helper'

describe Sentence::ByWord do
  subject do
    described_class.run!(
      word:                 word.word,
      language:             language,
      translation_language: translation_language
    )
  end

  context do
    let(:language) { 'rus' }
    let(:translation_language) { 'eng' }
    let!(:word) do
      create :word,
             word:      'Привет',
             sentences: [sentence],
             language:  language
    end
    let(:sentence) do
      create :sentence,
             sentence:     'Reply to answer',
             translations: [translation],
             language:     language
    end
    let(:translation) do
      create :sentence,
             sentence: 'Ответ на привет',
             language: translation_language
    end

    it do
      expect(subject.sentence).to    eq('Reply to answer')
      expect(subject.translation).to eq('Ответ на привет')
      expect(subject.text).to        eq("        Reply to answer\n\n        * * *\n\n        Ответ на привет\n")
    end
  end
end
