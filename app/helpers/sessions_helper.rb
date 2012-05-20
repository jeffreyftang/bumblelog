module SessionsHelper

	def sign_in(user)
		session[:remember_token] = user.id
		self.current_user = user
	end
	
	def signed_in?
		current_user ? true : false
	end	
	
	def sign_out
		session[:remember_token] = nil
		self.current_user = nil
		redirect_to root_path
	end
	
	def current_user=(user)
		@current_user = user
	end
	
	def current_user
		@current_user ||= User.find_by_id(session[:remember_token]) if session[:remember_token]
	end
	
	# Access Control
	
	def ensure_logged_in
		ask_to_sign_in unless signed_in?
	end
	
	def ensure_correct_user
		@user = User.find(params[:id])
		unless @user == current_user
			flash[:notice] = "You don't have permission to do that."	
			redirect_to(root_path)
		end
	end
	
	def members_only
		deny_access unless current_user.member?
	end
	
	def admins_only
		deny_access unless current_user.admin?
	end
	
	def owner_only
		deny_access unless current_user.owner?
	end
	
	# Friendly Redirect
	
	def redirect_back_or_to(target)
		if session[:stored_location]
			redirect_to session[:stored_location]
			clear_stored_location
		else
			redirect_to target
		end
	end
	
	private
	
		def store_location
			session[:stored_location] = request.fullpath
		end
	
		def clear_stored_location
			session[:stored_location] = nil
		end
		
		def ask_to_sign_in
			store_location
			flash[:notice] = 'Please sign in to access this page.'
			redirect_to(signin_path)
		end
		
		def deny_access
			flash[:notice] = "You don't have permission to do that."
			redirect_to(root_path)
		end
		
end
