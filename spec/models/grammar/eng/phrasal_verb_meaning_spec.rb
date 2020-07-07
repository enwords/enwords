require 'rails_helper'

describe Grammar::Eng::PhrasalVerbMeaning do
  describe 'associations' do
    it { is_expected.to belong_to(:phrasal_verb).class_name('Grammar::Eng::PhrasalVerb') }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:value) }
  end
end
