class PagesController < ApplicationController

	layout :choose_layout

	before_filter :ensure_logged_in

  def home
  	@title = 'Welcome'
  end

  def blog
  	@posts = Post.all.delete_if { |p| !p.published? }
  end
  
  def choose_layout
  	if action_name == 'home'
  		'home_layout'
  	else
  		'application'
  	end
  end

end
