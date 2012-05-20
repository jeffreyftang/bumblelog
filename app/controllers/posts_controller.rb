class PostsController < ApplicationController

	before_filter :ensure_logged_in
	before_filter :members_only, :only => [:new, :create, :edit]

  def new
  end
  
  def create
  end

  def edit
  end

  def show
  end

  def index
  end

end
