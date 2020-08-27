require 'rails_helper'

describe Subscription do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:payment) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:plan) }
    it { is_expected.to validate_presence_of(:status) }
  end
end
