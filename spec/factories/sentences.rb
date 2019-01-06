FactoryBot.define do
  factory :sentence do
    id       { rand(10**5) }
    language { 'eng' }
    value { FFaker::BaconIpsum.sentence }
  end

  factory :eng_sentence, parent: :sentence do
    language { 'eng' }
    value { FFaker::BaconIpsum.sentence }
  end
end
