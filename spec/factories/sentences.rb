FactoryBot.define do
  factory :sentence do
    language { 'eng' }
    sentence { FFaker::BaconIpsum.sentence }
  end

  factory :eng_sentence, parent: :sentence do
    language { 'eng' }
    sentence { FFaker::BaconIpsum.sentence }
  end
end
