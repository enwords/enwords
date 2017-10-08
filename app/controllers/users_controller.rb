class UsersController < ApplicationController
  def update_proficiency
    User::UpdateProficiency.run(user:  current_user,
                                limit: params[:proficiency_level])
    Rails.cache.delete("skyeng_words_user_#{current_user.id}")
    redirect_back(fallback_location: root_path)
  end
end
