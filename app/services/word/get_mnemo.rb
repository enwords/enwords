class Word::GetMnemo < ActiveInteraction::Base
  URL = "http://www.englspace.com/mnemo/index.php".freeze

  object :word

  def execute
    mnemos = word.mnemos
    return [:ok, mnemos] if mnemos.present?

    page          = Nokogiri::HTML(response.force_encoding('windows-1251').encode('utf-8'))
    callout       = page.css('.callout', '.primary').last
    matches_count = callout.css('.h2').last.css('strong').text.to_i

    if matches_count > 0
      callout.css('p').remove
      callout.css('strong').remove
      callout.css('em').remove
      callout.css('.author').remove
      mnemos_text_array =
        callout.text.strip.split(/\[.*?\]\s*\-\s*/).map(&:strip).select(&:present?)

      ApplicationRecord.transaction do
        mnemos_text_array.each do |content|
          Mnemo.create!(word: word, language: 'rus', content: content)
        end
      end
    else
      Mnemo.create!(word: word, language: 'rus', content: nil)
    end

    [:ok, word.reload.mnemos]
  end

  def response
    @response ||= HTTParty.post(URL, body: "pattern=!#{word.word}!").body
  end
end
