require 'rails_helper'

describe Mailer::SendPromoEmailWorker do
  subject { described_class.new.perform }

  include_examples 'should present at the cron schedule'
end
