class Post < ActiveRecord::Base

	attr_accessible :title, :content
	
	validates :title, :presence => true
	validates :content, :presence => true

end
