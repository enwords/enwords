class AddDataToGrammarEngIrregularVerbs < ActiveRecord::Migration[5.0]
  def change
    infinitives.each do |line|
      infinitive, simple_past, past_participle = line.split(';')
      Grammar::Eng::IrregularVerb.create \
        infinitive:      infinitive,
        simple_past:     simple_past.split(','),
        past_participle: past_participle.split(',')
    end
  end

  def infinitives
    File.read('db/infinitives.csv')
  end
end
