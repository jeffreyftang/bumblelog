class UsersController < ApplicationController
  
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
  end
  
  def index
  end

end
