module Sidekiq
  module CronHelper
    shared_examples 'should present at the cron schedule' do
      context do
        let(:cron_list) { YAML.load_file('config/schedule.yml') }

        it do
          result =
            cron_list.find { |_, hsh| hsh['class'] == described_class.to_s }.present?
          expect(result).to be_truthy
        end
      end
    end
  end
end
