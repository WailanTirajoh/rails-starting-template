class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy]
  before_action :set_posts, only: %i[index]

  # GET /posts
  def index; end

  # GET /posts/1
  def show; end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit; end

  # POST /posts
  def create
    @post = Post.new(post_params)

    if @post.save
      set_posts
      render turbo_stream: [
        turbo_stream.update('posts', partial: 'posts/posts', locals: { posts: @posts }),
        turbo_stream.update('notice', partial: 'shared/notice', locals: { notice: 'Post was successfully created.' }),
        turbo_stream.append('modal', partial: 'shared/close_modal') # Trigger modal close
      ]
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1
  def update
    if @post.update(post_params)
      set_posts
      render turbo_stream: [
        turbo_stream.update('posts', partial: 'posts/posts', locals: { posts: @posts }),
        turbo_stream.update('notice', partial: 'shared/notice', locals: { notice: 'Post was successfully updated.' }),
        turbo_stream.append('modal', partial: 'shared/close_modal') # Trigger modal close
      ]
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1
  def destroy
    @post.destroy!

    set_posts
    render turbo_stream: [
      turbo_stream.update('posts', partial: 'posts/posts', locals: { posts: @posts }),
      turbo_stream.update('notice', partial: 'shared/notice', locals: { notice: 'Post was successfully deleted.' })
    ]
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  def set_posts
    sort_column = params[:sort] || 'created_at'
    sort_direction = params[:direction].presence_in(%w[asc desc]) || 'desc'

    @posts = Post.order("#{sort_column} #{sort_direction}").page(params[:page]).per(10)
  end

  # Only allow a list of trusted parameters through.
  def post_params
    params.require(:post).permit(:title, :body)
  end
end
