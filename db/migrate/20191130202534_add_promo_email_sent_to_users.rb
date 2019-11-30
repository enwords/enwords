class AddPromoEmailSentToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :promo_email_sent, :boolean, default: false
  end
end
