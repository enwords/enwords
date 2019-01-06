FactoryBot.define do
  factory :word do
    id { rand(10**5) }
    language { 'eng' }
    value { FFaker::BaconIpsum.word }
    pos { 'n' }
  end

  factory :eng_word, parent: :word do
    language { 'eng' }
    value { FFaker::BaconIpsum.word }
    pos { 'n' }
  end
end
