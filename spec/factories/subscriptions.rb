FactoryBot.define do
  factory :subscription do
    user
    payment { create(:payment, user: user) }
    plan { Subscription.plans.keys.sample }
    status { Subscription.statuses.keys.sample }
    expires_at { 1.year.from_now }
  end
end
