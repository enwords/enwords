class SkyengSetting < ApplicationRecord
  class Create < ActiveInteraction::Base
    string :email
    object :user

    validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i,
                                message: :email_invalid }

    def execute
      skyeng_setting.email = email
      skyeng_setting.aasm_state = 'token_adding'

      if skyeng_setting.save
        skyeng_setting
      else
        errors.add(:skyeng_setting, t('skyeng_settings.errors.did_not_save'))
      end
    end

    private

    def skyeng_setting
      @skyeng_setting ||=
        SkyengSetting.where(user_id: user.id).first_or_initialize
    end
  end
end
