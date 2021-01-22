module Admin::V1
  class PostsController < ApiController
    skip_before_action :authenticate_user!, only: :index

    def index
      @posts = Post.all
    end
  end
end
