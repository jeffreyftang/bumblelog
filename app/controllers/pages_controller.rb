class PagesController < ApplicationController

	before_filter :ensure_logged_in

  def home
  end

  def blog
  	@posts = Post.all.delete_if { |p| !p.published? }
  end

  def cpanel
  end

end
