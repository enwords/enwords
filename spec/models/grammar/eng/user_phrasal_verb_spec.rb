require 'rails_helper'

describe Grammar::Eng::UserPhrasalVerb do
  subject { create(:grammar_eng_user_phrasal_verb) }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:phrasal_verb).class_name('Grammar::Eng::PhrasalVerb') }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:phrasal_verb) }
  end
end
