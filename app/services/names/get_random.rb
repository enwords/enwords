module Names
  class GetRandom < ActiveInteraction::Base
    DATA = YAML.load_file('db/names.yml')

    private

    string :group, default: -> { DATA.keys.shuffle.sample }
    string :name, default: -> { DATA[group]&.shuffle&.sample }

    def execute
      {
        name: name,
        phrase: Word::GeneratePhrase.run!(pos_n: name),
        group: group
      }
    end
  end
end