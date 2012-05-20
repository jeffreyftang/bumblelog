class Post < ActiveRecord::Base

	attr_accessible :title, :content
	
	belongs_to :user
	
	validates :title, :presence => true
	validates :content, :presence => true

end
