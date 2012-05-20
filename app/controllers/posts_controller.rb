class PostsController < ApplicationController

	before_filter :ensure_logged_in
	before_filter :members_only, :only => [:new, :create, :edit]

  def new
  	@post = Post.new
  	@title = 'Create new post'
  end
  
  def create
  end

  def edit
  end

  def show
		if params[:id]
  		@post = Post.find_by_id(params[:id])
  	else
  		@post = Post.find_by_slug(params[:post][:slug])
  	end 		
  end

  def index
  end

end
