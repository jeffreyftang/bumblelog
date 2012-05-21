class Post < ActiveRecord::Base

	attr_accessible :title, :content, :published
	
	belongs_to :user
	
	validates :title, :presence => true
	validates :content, :presence => true
	validates :user_id, :presence => true
	
	def publish
		self.published = true
		self.save
	end
	
	def unpublish
		self.published = false
		self.save
	end
	
	def published_status_as_string
		if self.published?
			'Published'
		else
			'Draft'
		end
	end

end
