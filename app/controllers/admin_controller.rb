class AdminController < ApplicationController
  layout 'admin'

  before_action :authenticate_user!
  before_action :admin_only

  def index; end

  private

  def admin_only
    return if current_user.admin?

    redirect_to root_path(locale: :en), alert: 'Access denied'
  end
end
