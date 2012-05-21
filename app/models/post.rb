class Post < ActiveRecord::Base

	attr_accessible :title, :content, :published
	
	belongs_to :user
	
	validates :user_id, :presence => true
	
	def publish
		self.published = true
		self.save
	end
	
	def unpublish
		self.published = false
		self.save
	end

end
