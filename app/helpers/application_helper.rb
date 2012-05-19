module ApplicationHelper

	def title
		default_title = 'The Bumblelog'
		if @title.nil?
			default_title
		else
			@title
		end
	end

end
