module Admin
  class TrainingsController < AdminController
    def index
      @trainings = Training.order(updated_at: :desc).paginate(page: params[:page], per_page: 10)
    end
  end
end
