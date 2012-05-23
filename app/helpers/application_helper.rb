module ApplicationHelper

	def title
		default_title = 'The Bumblelog'
		if @title.nil?
			default_title
		else
			@title
		end
	end
	
	def cpanel?
		(params[:action] == 'cpanel') || (params[:controller] == 'posts' && params[:action] != 'show') || (params[:controller] == 'users' && params[:action] != 'new')
	end

	def blog?
		(params[:action] == 'blog') || (params[:controller] == 'posts' && params[:action] == 'show')
	end

end
