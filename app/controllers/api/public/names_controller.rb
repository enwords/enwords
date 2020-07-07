module API
  module Public
    class NamesController < ::API::BaseController
      def random
        render json: Names::GetRandom.run!(group: params[:group].presence)
      end
    end
  end
end
