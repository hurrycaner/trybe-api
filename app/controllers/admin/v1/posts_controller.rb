module Admin::V1
  class PostsController < ApiController
    skip_before_action :authenticate_user!, only: %i[index show]
    before_action :set_post, only: %i[show update]

    def index
      @posts = Post.all
    end

    def show; end

    def create
      @post = Post.new(post_params)
      @post.user = current_user
      save_post!
    end

    def update
      @post.attributes = post_params
      save_post!
    end

    private

    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      return {} unless params.key?(:post)

      params.require(:post).permit(:title, :content)
    end

    def save_post!
      @post.save!
      render :show
    rescue StandardError
      render json: { errors: { fields: @post.errors.messages } }, status: :unprocessable_entity
    end
  end
end
