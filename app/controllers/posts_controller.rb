class PostsController < ApplicationController

	before_filter :ensure_logged_in
	before_filter :members_only, :only => [:new, :create, :edit, :update, :destroy]
	before_filter :ensure_correct_user_or_admin, :only => [:edit, :update, :destroy]

  def new
  	@post = Post.new
  	@title = 'Create new post'
  end
  
  def create
  	@post = current_user.posts.build(params[:post])
  	if @post.save
  		flash[:success] = 'Post saved.'
  		redirect_to edit_post_path(@post)
  	else
  		flash.now[:error] = 'There was a problem saving your post.'
  		render :new
  	end
  end

  def edit  		
  	# @post = Post.find(params[:id]) is taken care of by the before_filter
  end
  
  def update
  	# @post = Post.find(params[:id]) is taken care of by the before_filter
  	if @post.update_attributes(params[:post])
  		flash[:success] = 'Post updated.'
  		redirect_to edit_post_path(@post)
  	else
  		flash[:error] = 'There was a problem editing the post.'
  		render :edit
  	end
  end

  def show
		if params[:id]
  		@post = Post.find_by_id(params[:id])
  	else
  		@post = Post.find_by_slug(params[:slug])
  	end 		
  end

  def destroy
  	@post = Post.find(params[:id])
  	if @post.destroy
  		flash[:success] = 'Post deleted.'
  		redirect_to root_path
  	else
  		flash[:error] = 'There was a problem deleting the post.'
  		redirect_to root_path
  	end
  end

end
