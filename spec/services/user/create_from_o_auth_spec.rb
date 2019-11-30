require 'rails_helper'

describe User::CreateFromOAuth do
  subject { described_class.run!(params: params) }

  let(:params) do
    OmniAuth::AuthHash.new(
      provider: 'vkontakte',
      uid: SecureRandom.uuid,
      credentials: { token: SecureRandom.uuid, expires_at: Time.current.to_i },
      info: { email: FFaker::Internet.email }
    )
  end

  it 'creates UserAuthentication' do
    expect { subject }.to change { UserAuthentication.count }.by(1)
  end

  it 'creates User' do
    expect { subject }.to change { User.count }.by(1)
  end

  it 'returns User' do
    expect(subject).to be_a(User)
  end
end
