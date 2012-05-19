class UsersController < ApplicationController

	before_filter :ensure_logged_in, :only => [:edit, :update, :show]
	before_filter :ensure_correct_user, :only => [:edit, :update]

	def new
  	@user = User.new
  	@title = 'Sign up'
  end
  
  def show
  	@user = User.find(params[:id])
  	@title = @user.get_name
  end
  
  def create
  	@user = User.new(params[:user])
  	if @user.save
  		flash[:success] = 'Welcome!'
  		redirect_to user_path(@user)
  	else
  		render 'new'
  	end
  end
  
  def edit
  	@user = User.find(params[:id])
  	@title = 'Editing ' + @user.get_name
  end
  
  def update
  	@user = User.find(params[:id])
  	params[:user].delete_if { |k, v| v.blank? && (k != 'display_name') }
  	if @user.update_attributes(params[:user])
  		flash[:success] = 'Update successful.'
  		redirect_to @user
  	else
  		@title = 'Editing ' + @user.get_name
  		render 'edit'
  	end
  end
  	
  
  def index
  end

end
