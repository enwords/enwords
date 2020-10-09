class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  def create
    _, url = Subscriptions::Create.run!(user: current_user, plan: params[:plan])
    redirect_to url
  end

  def after_checkout
    subscription = Subscriptions::Activate.run!(subscription: Subscription.find_by(payment_id: params[:payment_id]))
    redirect_to root_path(premium: subscription.status_active?, locale: I18n.locale)
  end
end
