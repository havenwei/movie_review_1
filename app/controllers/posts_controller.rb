class PostsController < ApplicationController
  before_action :authenticate_user!, :only => [:new, :create, :edit, :update, :destroy]
  before_action :find_post_and_check_permission, :only => [:edit, :update, :destroy]
  def new
    @group = Group.find(params[:group_id])
    if current_user.is_member_of?(@group)
      @post = Post.new
    else
      redirect_to group_path(@group)
      flash[:warning] = "请收藏该电影，否则无法发表影评!"
    end
  end

  def create
    @group = Group.find(params[:group_id])
    @post = Post.new(post_params)
    @post.group = @group
    @post.user = current_user

    if @post.save
      redirect_to group_path(@group)
    else
      render :new
    end
  end

  def edit
    @group = Group.find(params[:group_id])
  end

  def update
    @group = Group.find(params[:group_id])
    if @post.update(post_params)
      redirect_to account_posts_path, notice: "Update Success"
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to account_posts_path, alert: "Post deleted"
  end

  private

  def find_post_and_check_permission
    @post = Post.find(params[:id])
    if current_user != @post.user
      redirect_to root_path, alert: "You have no permission"
    end
  end

  def post_params
    params.require(:post).permit(:content)
  end

end
