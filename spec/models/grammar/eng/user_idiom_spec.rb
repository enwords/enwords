require 'rails_helper'

describe Grammar::Eng::UserIdiom do
  subject { create(:grammar_eng_user_idiom) }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:idiom).class_name('Grammar::Eng::Idiom') }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:idiom) }
  end
end
