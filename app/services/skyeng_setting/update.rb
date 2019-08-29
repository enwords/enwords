class SkyengSetting < ApplicationRecord
  class Update < ActiveInteraction::Base
    string :email
    string :token
    object :skyeng_setting

    validates :skyeng_setting, :token, :email, presence: true
    validates :email, format: {
      with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i,
      message: :email_invalid
    }

    def execute
      if skyeng_setting.update(token: token, email: email)
        skyeng_setting
      else
        errors.add(:skyeng_setting, t('skyeng_settings.errors.did_not_save'))
      end
    end
  end
end
