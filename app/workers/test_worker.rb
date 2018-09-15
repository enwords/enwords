# frozen_string_literal: true

class TestWorker
  include Sidekiq::Worker

  def perform(*)
    ApplicationMailer.test_email('sadovnikov.js@gmail.com').deliver
    :ok
  end
end
