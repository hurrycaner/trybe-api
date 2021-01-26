module Admin::V1
  class HomeController < ApiController
    skip_before_action :authenticate_user!
    skip_before_action :restrict_access_for_admin!

    def index
      render json: { ok: true }
    end
  end
end
