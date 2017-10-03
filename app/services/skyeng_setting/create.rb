class SkyengSetting::Create < ActiveInteraction::Base
  string :email
  object :user

  validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, message: :email_invalid }
  validates :user, presence: true

  def execute
    user.skyeng_setting = skyeng_setting

    if user.save
      user.skyeng_setting
    else
      errors.add(:skyeng_setting, t('skyeng_settings.did_not_save'))
    end
  end

  private

  def skyeng_setting
    @_skyeng_setting ||=
      SkyengSetting.where(email: email.downcase).first_or_initialize
  end
end
