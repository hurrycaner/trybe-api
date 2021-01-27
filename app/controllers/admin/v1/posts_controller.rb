module Admin::V1
  class PostsController < ApiController
    skip_before_action :authenticate_user!, only: %i[index show]
    skip_before_action :restrict_access_for_admin!, only: %i[index show create update]
    before_action :set_post, only: %i[show update destroy]

    def index
      @loading_service = Admin::ModelLoadingService.new(Post.all, searchable_params)
      @loading_service.call
    end

    def show; end

    def create
      @post = Post.new(post_params)
      @post.user = current_user
      save_post!
    end

    def update
      if owner_or_admin?(@post)
        @post.attributes = post_params
        save_post!
      else
        render_error(message: 'Forbidden access', status: :forbidden)
      end
    end

    def destroy
      @post.destroy!
    rescue StandardError
      render_error(fields: @post.errors.messages)
    end

    private

    def set_post
      @post = Post.find(params[:id])
    end

    def searchable_params
      params.permit({ search: {} }, { order: {} }, :page, :length)
    end

    def post_params
      return {} unless params.key?(:post)

      params.require(:post).permit(:title, :content)
    end

    def owner_or_admin?(record)
      record.user == current_user || current_user.admin?
    end

    def save_post!
      @post.save!
      render :show
    rescue StandardError
      render_error(fields: @post.errors.messages)
    end
  end
end
