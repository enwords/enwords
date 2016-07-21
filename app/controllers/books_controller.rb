class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  # GET /books
  # GET /books.json
  def index
    @books = Book.where(user: current_user)
  end

  # GET /books/1
  # GET /books/1.json
  def show
    unless @book.user == current_user
      redirect_to books_path
    end
  end

  # GET /books/new
  def new

    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books
  # POST /books.json
  def create
    @book = Book.new(book_params)
    @book.language = current_user.learning_language
    @book.user = current_user

    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: 'Book was successfully created.' }
        format.json { render :show, status: :created, location: @book }

         count_words_in_text

      else
        format.html { render :new }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1
  # PATCH/PUT /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url, notice: 'Book was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def count_words_in_text
    text =  @book.content.downcase.gsub(/[[:punct:]\d]/, '')
    words = text.split(" ")
    frequencies = Hash.new(0)
    words.each { |word| frequencies[word] += 1 }
    frequencies = frequencies.sort_by{ |a, b| b}.collect{|a, b| a}.reverse!

    frequencies.each { |word, frequency| puts word + " " + frequency.to_s }

    create_words_books(frequencies)

  end

  def create_words_books(frequencies)
    @book.words = Word.where(word: frequencies,
    language: current_user.learning_language)
  end

  # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_params
      params.require(:book).permit(:content, :title)
    end
end
