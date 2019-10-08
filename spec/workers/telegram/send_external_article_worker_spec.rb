require 'rails_helper'

describe Telegram::SendExternalArticleWorker do
  subject { described_class.new.perform }

  include_examples 'should present at the cron schedule'
end
