# frozen_string_literal: true

class CertbotRenewWorker
  include Sidekiq::Worker

  def perform(*)
    `sudo certbot renew --force-renewal & sudo service nginx restart`
  end
end
