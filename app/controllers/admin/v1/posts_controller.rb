module Admin::V1
  class PostsController < ApiController
    skip_before_action :authenticate_user!, only: :index
    before_action :set_post, only: %i[show]

    def index
      @posts = Post.all
    end

    def show; end

    private

    def set_post
      @post = Post.find(params[:id])
    end
  end
end
