module Admin::V1
  class UsersController < ApiController
    skip_before_action :authenticate_user!, only: %i[index show]
    skip_before_action :restrict_access_for_admin!, only: %i[index show]
    before_action :set_user, only: %i[show update destroy turn_admin]

    def index
      @loading_service = Admin::ModelLoadingService.new(search_scope, searchable_params)
      @loading_service.call
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
      render_error(fields: @user.errors.messages)
    end

    # simple action to help in the usage of application.
    # in production we should probably do such thing manually.
    def turn_admin
      if current_user.profile.downcase == 'admin'
        @user.profile = 'admin'
        save_user!
      else
        render_error(message: 'Acesso negado.', status: :unauthorized)
      end
    rescue StandardError
      render_error(fields: @user.errors.messages)
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def searchable_params
      params.permit({ search: {} }, { order: {} }, :page, :length)
    end

    def search_scope
      current_user ? User.where.not(id: current_user.id) : User.all
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
      render_error(fields: @user.errors.messages)
    end
  end
end
