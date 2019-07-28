module Admin
  class UsersController < AdminController
    before_action :set_user, only: %i[show update destroy]

    def index
      @users = User.order(updated_at: :desc).paginate(page: params[:page], per_page: 20)
    end

    def show; end

    def update
      if @user.update_attributes(secure_params)
        redirect_to admin_users_path, notice: 'User updated'
      else
        redirect_to admin_users_path, alert: 'Unable to update user'
      end
    end

    def destroy
      @user.destroy
      redirect_to admin_users_path, notice: 'User deleted'
    end

    def create
      @user = User.new(secure_params)

      respond_to do |format|
        if @user.save
          format.html { redirect_to @user, notice: 'User was successfully created.' }
          format.json { render :show, status: :created, location: @user }
        else
          format.html { render :new }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end

    def stat
      render :stat, locals: { data: User.group(:created_at).count }
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def secure_params
      params.require(:user).permit(:role)
    end
  end
end
