require 'rails_helper'

describe Grammar::Eng::PhrasalVerb do
  subject { create(:grammar_eng_phrasal_verb) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:weight) }
    it { is_expected.to validate_presence_of(:value) }
    it { is_expected.to validate_uniqueness_of(:value) }
  end
end
