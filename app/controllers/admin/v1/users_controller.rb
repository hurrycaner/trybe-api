module Admin::V1
  class UsersController < ApiController
    before_action :set_user, only: %i[show]

    def index
      @users = User.all
    end

    def show; end

    private

    def set_user
      @user = User.find(params[:id])
    end
  end
end
