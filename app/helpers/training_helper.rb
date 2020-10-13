module TrainingHelper
  def clean_word(word)
    word.gsub(/\W/, '').downcase
  end

  def grammar_training_data(clean_word)
    {
      autocomplete: 'off',
      style: "width: #{clean_word.size * 15}px",
      class: 'input-word',
      maxlength: clean_word.size,
      autofocus: true,
      data: { 'hidden-word' => clean_word }
    }
  end
end
