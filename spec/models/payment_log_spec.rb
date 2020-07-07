require 'rails_helper'

describe PaymentLog do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:provider) }
    it { is_expected.to validate_presence_of(:payment_type) }
  end
end
