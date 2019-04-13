module Api
  module Public
    class NamesController < ::Api::BaseController
      def random
        render json: Names::GetRandom.run!(group: params[:group].presence)
      end
    end
  end
end
