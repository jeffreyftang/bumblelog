class UsersController < ApplicationController

	layout :choose_layout

	before_filter :ensure_logged_in, :only => [:edit, :update, :show, :destroy]
	before_filter :ensure_correct_user_or_admin, :only => [:edit, :update]
	before_filter :admins_only, :only => [:destroy]
	
	before_filter :non_signed_in_only, :only => [:new, :create]

	def choose_layout
		if action_name == 'new'
			'signin'
		else
			'application'
		end
	end
	
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
  		end
  		flash[:success] = 'Welcome!'
  		sign_in @user
  		redirect_to user_path(@user)
  	else
  		flash.now[:notice] = 'There was a problem creating your account.'
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
  	access_lvl = params[:user].delete(:access_level)
		
		# Modify attributes other than access level
  	@user.attributes = params[:user]
  	
  	# Set the access level manually if the current user is an admin
  	if current_user.admin?
  		@user.access_level = access_lvl
  	end
  	
  	if @user.save
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
  	@users = User.all
  end
  


end
