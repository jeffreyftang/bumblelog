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
  	@post.published = true if params[:commit] == 'Publish'
  	if @post.published? && @post.published_at.blank?
  		@post.published_at = DateTime.now
  	end
  	if @post.save
  		if @post.published?
  			flash[:success] = "Post published. <a href='" + @post.get_path + "'>See it here.</a>"
  		else
  			flash[:success] = "Post saved."
  		end
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
  	
  	# Set the published at time if the post was previously unpublished.
  	if @post.published_at.blank? && params[:post][:published] && params[:post][:published_at].blank?
  		params[:post][:published_at] = DateTime.now
  	end
  	if @post.update_attributes(params[:post])
  		if @post.published?
  			flash[:success] = "Post updated. <a href='" + @post.get_path + "'>See it here.</a>"
  		else
  			flash[:success] = "Post updated."
  		end
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
  		unless params[:year].to_i == @post.published_at.year && params[:month].to_i == @post.published_at.month
  			@post = nil
  		end
  	end
  	raise ActiveRecord::RecordNotFound.new('not found') unless @post.published?	
  end

  def destroy
  	@post = Post.find(params[:id])
  	if @post.destroy
  		flash[:success] = 'Post deleted.'
  		redirect_to posts_path
  	else
  		flash[:error] = 'There was a problem deleting the post.'
  		redirect_to posts_path
  	end
  end
  
  def index
  	@posts = Post.all
  	@posts.sort_by! do |p|
  		if p.published?
  			p.published_at
  		else
  			p.updated_at
  		end
  	end
  	@posts.reverse!
  end

end
