module Grammar::Eng
  class ConditionalSentencesController < ApplicationController
    before_action :authenticate_user!

    def show
      @conditional_sentence = ConditionalSentence.order('RANDOM()').first
    end
  end
end
