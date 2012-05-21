class PagesController < ApplicationController

	before_filter :ensure_logged_in

  def home
  end

  def blog
  end

  def cpanel
  end

end
