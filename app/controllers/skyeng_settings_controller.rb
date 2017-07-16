class SkyengSettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :fetch_settings, only: %i[show update add_token edit]

  def new
    @skyeng_setting = SkyengSetting.new
  end

  def show
    render @skyeng_setting.aasm_state.to_s
  end

  def edit; end

  def create
    creating = SkyengSetting::Create.run(user: current_user, email: skyeng_setting_params[:email])

    if creating.valid?
      skyeng_setting = creating.result
      Api::Skyeng.send_token(email: skyeng_setting.email)
      redirect_to skyeng_setting_path, notice: t('skyeng_settings.add_token', email: skyeng_setting.email)
    else
      redirect_to :back, alert: creating.errors.messages.values.join('<br>')
    end
  end

  def update
    updating = SkyengSetting::Update.run(skyeng_setting_params.merge(skyeng_setting: @skyeng_setting))

    if updating.valid?
      redirect_to skyeng_setting_path, notice: t('skyeng_settings.finished')
    else
      redirect_to :back, alert: updating.errors.messages.values.join('<br>')
    end
  end

  def add_token
    updating = SkyengSetting::AddToken.run(skyeng_setting: @skyeng_setting,
                                           token:          skyeng_setting_params[:token].strip)

    if updating.valid?
      redirect_to skyeng_setting_path, notice: t('skyeng_settings.finished')
    else
      redirect_to :back, alert: updating.errors.messages.values.join('<br>')
    end
  end

  private

  def skyeng_setting_params
    params.require(:skyeng_setting).permit(:email, :token).tap { |i| i[:email].strip!.downcase! rescue nil }
  end

  def fetch_settings
    @skyeng_setting ||= current_user.skyeng_setting
  end
end
