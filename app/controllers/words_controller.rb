class WordsController < ApplicationController
  before_action :authenticate_user!


  def word_action
    if params[:words_ids]
      case params[:commit]
        when 'to_learning'
          set_word_status false
        when 'to_learned'
          set_word_status true
        when 'to_unknown'
          delete_word_status
        when 'to_training'
          set_training
        else
          redirect_to(root_path)
      end
    end
  end

  def set_training
    Training.delete_all(user_id: current_user)
    arr = []
    val = []

    params[:words_ids].each do |wid|
      arr << Sentence.joins(:sentences_words).where(sentences_words: {word_id: wid}).joins(:sentences).where(sentences_sentences: {language: current_user.native_language}).order("RANDOM()").limit(5)
    end
    arr.each do |sentences_arr|
      sentences_arr.each do |sen|
        val << {user_id: current_user.id, sentence_id: sen.id}
      end
    end
    Training.create! val
    redirect_to(training_path)
  end

  def training
    @sentences = Sentence.where(id: Training.select(:sentence_id).where(user: current_user)).includes(:audio).
        paginate(page: params[:page], per_page: 1)
    @native_language = current_user.native_language
  end

  def delete_word_status
    WordStatus.delete_all(user_id: current_user, word_id: params[:words_ids])
    redirect_to(:back)
  end

  def set_word_status(bool)
    params[:words_ids].each do |wid|
      begin
        WordStatus.create!(user_id: current_user.id, word_id: wid, learned: bool)
      rescue
        WordStatus.where(user_id: current_user, word_id: wid).update_all(learned: bool)
      end
    end
    redirect_to(:back)
  end

  def set_status_on_training
    begin
      WordStatus.create!(user_id: params[:user_id], word_id: params[:word_id], learned: params[:bool])
      return
    rescue
      WordStatus.where(user_id: params[:user_id], word_id: params[:word_id]).update_all(learned: params[:bool])
    end
  end


  # GET /words
  # GET /words.json
  def index
    if params[:status]
      case params[:status]
        when 'learning'
          @title = 'Изучаемые слова'
          learning
        when 'learned'
          @title = 'Выученные слова'
          learned
        when 'unknown'
          @title = 'Неизвестные слова'
          unknown
      end
    elsif params[:search]
      @title = 'Результат поиска'
      word_search
    else
      @title = 'Все слова'

      sql = "
      select w.id, w.word from words w
join sentences_words sw on sw.word_id = w.id
join sentences s1 on sw.sentence_id = s1.id
join links l on l.sentence_1_id = s1.id
join sentences s2 on l.sentence_2_id = s2.id
where w.language = 'jpn'
and s1.language = 'jpn'
and s2.language = 'rus'
group by w.id
order by w.id
offset 1000
limit 20
"
      @words = ActiveRecord::Base.connection.execute(sql)


#       # @words = Word.joins(:sentences).joins(:sentences).where(s1: {language: current_user.learning_language}, s2: {language: current_user.native_language}, words: {language: current_user.learning_language})
#       #                .group(:id).order(:id).paginate(page: params[:page], per_page: 20)
#


      # Edge.joins(:first, :second).where(nodes: {value: 1}, seconds_edges: {value: 2})
      # SELECT "edges".* FROM "edges" INNER JOIN "nodes" ON "nodes"."id" = "edges"."first_id" INNER JOIN "nodes" "seconds_edges" ON "seconds_edges"."id" = "edges"."second_id" WHERE "nodes"."value" = 1 AND "seconds_edges"."value" = 2


# @words = Word.joins(:sentences).where(language: current_user.learning_language).joins(:sentences).
#     where(sentences_sentences: {language: current_user.native_language}).where(language: current_user.learning_language)
#              .group(:id).order(:id).paginate(page: params[:page], per_page: 20)

# @words = Word.where(Sentence.where(language: current_user.learning_language).joins(:sentences).
#     where(sentences: {language: current_user.native_language})).where(language: current_user.learning_language).
#               group(:id).order(:id).paginate(page: params[:page], per_page: 20)
#
    end
  end

  def learning
    @words = current_user.words.where(language: current_user.learning_language).where(word_statuses: {learned: false}).order(:id).
        paginate(page: params[:page], per_page: 20)
  end

  def learned
    @words = current_user.words.where(language: current_user.learning_language).where(word_statuses: {learned: true}).order(:id).
        paginate(page: params[:page], per_page: 20)
  end

  def unknown
    @words = Word.joins(:sentences).where(sentences: {language: current_user.learning_language}).
        where.not(id: WordStatus.select(:word_id).where(user: current_user)).group(:id).order(:id).
        paginate(page: params[:page], per_page: 20)
  end


  def word_search
    if params[:search]
      @words = Word.joins(:sentences).where(sentences: {language: current_user.learning_language}).
          where('word LIKE ?', "#{params[:search].downcase}%").
          group(:id).order(:id).paginate(page: params[:page], per_page: 20)
    end
  end


  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def word_params
    params.require(:word).permit(:id, :word)
  end
end