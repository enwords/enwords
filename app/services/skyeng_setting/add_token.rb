class SkyengSetting < ApplicationRecord
  class AddToken < ActiveInteraction::Base
    string :token
    object :skyeng_setting

    validates :skyeng_setting, :token, presence: true

    def execute
      if skyeng_setting.update(token: token)
        skyeng_setting.finish!
        skyeng_setting
      else
        errors.add(:skyeng_setting, t('skyeng_settings.errors.did_not_save'))
      end
    end
  end
end
