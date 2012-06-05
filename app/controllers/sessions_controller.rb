class SessionsController < ApplicationController

	layout 'signin'
	
	before_filter :non_signed_in_only, :only => [:new, :create]
  
  def new
  	@title = 'Sign in'
  end
  
  def create
  	user = User.authenticate(params[:session][:username], params[:session][:password])
  	unless user
  		flash[:error] = "Invalid username/password combination."
  		@title = 'Sign in'
  		redirect_to signin_path
  	else
  		sign_in user
  		redirect_to root_path
  	end
  end
  
  def destroy
  	sign_out
  end

end
