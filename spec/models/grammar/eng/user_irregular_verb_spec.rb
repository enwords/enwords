require 'rails_helper'

describe Grammar::Eng::UserIrregularVerb do
  subject { create(:grammar_eng_user_irregular_verb) }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:irregular_verb).class_name('Grammar::Eng::IrregularVerb') }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:irregular_verb) }
  end
end
