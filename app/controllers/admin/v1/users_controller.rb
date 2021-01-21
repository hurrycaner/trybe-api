module Admin::V1
  class UsersController < ApiController
    before_action :set_user, only: %i[show update destroy]
    skip_before_action :authenticate_user!, only: :create

    def index
      @users = User.all
    end

    def show; end

    def create
      @user = User.new(user_params)
      save_user!
    end

    def update
      @user.attributes = user_params
      save_user!
    end

    def destroy
      @user.destroy!
    rescue StandardError
      render json: { errors: { fields: @user.errors.messages } }
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      return {} unless params.key?(:user)

      params.require(:user)
            .permit(:id, :name, :email, :image, :password, :password_confirmation)
    end

    def save_user!
      @user.save!
      render :show
    rescue StandardError
      render json: { errors: { fields: @user.errors.messages } }, status: :unprocessable_entity
    end
  end
end
