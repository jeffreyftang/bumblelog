class UsersController < ApplicationController

	before_filter :ensure_logged_in, :only => [:edit, :update, :show, :destroy]
	before_filter :ensure_correct_user_or_admin, :only => [:edit, :update]
	before_filter :admins_only, :only => [:destroy]

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
  		if @user == User.first && @user == User.last
  			@user.make_owner
  			@user.save
  		end
  		flash[:success] = 'Welcome!'
  		sign_in @user
  		redirect_to user_path(@user)
  	else
  		render 'new'
  	end 	
  	rescue ActiveRecord::StatementInvalid
  		redirect_to root_path 	
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
  	
  def destroy
  	user = User.find(params[:id])
  	unless user == current_user || user.owner?
  		user.destroy
  		flash[:success] = 'User deleted.'
  	else
  		flash[:notice] = "You don't have permission to delete this user."
  	end
  	redirect_to(users_path)
  end
  
  def index
  end
  


end
