class Post < ActiveRecord::Base

	attr_accessible :title, :content, :published, :published_at, :slug
	
	belongs_to :user
	
	slug_regex = /\A([a-z0-9-])+\z/i
	
	validates :title, :presence => true
	validates :content, :presence => true
	validates :user_id, :presence => true
	
	validates :slug, :uniqueness => { :case_sensitive => false }
	validates :slug, :format => { :with => slug_regex },
									 :allow_blank => true
									 
	
	default_scope :order => 'posts.published_at DESC'
	
	before_save :set_slug
	
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
	
	def get_path
		path = '/' + published_at.strftime('%Y') + '/' + published_at.strftime('%m') + '/' + slug
	end
	
	private
	
		def set_slug
			if slug.blank?
				self.slug = generate_slug(title)
			else
				self.slug = generate_slug(slug)
			end
		end
	
		def generate_slug(input)
			input.strip.downcase.gsub(/[\s.\/_]/, ' ').squeeze(' ').gsub(/[\s]/, '-').gsub(/[^\w-]/, '')
		end

end
