require 'digest'

class User < ActiveRecord::Base

	attr_accessor :password
	attr_accessible :name, :username, :display_name, :password, :password_confirmation
	
	has_many :posts

	username_regex = /\A[a-z](\w)+([a-z]|\d)\z/i

	validates :username, :presence => true,
									     :uniqueness => { :case_sensitive => false },
									  	 :length => { :within => (3..15) },
									  	 :format => { :with => username_regex }
									  	 
	validates :password, :presence => true,
											 :confirmation => true,
											 :length => { :within => (6..40) },
											 :on => :create
											 
	validates :password, :presence => true,
											 :confirmation => true,
											 :length => { :within => (6..40) },
											 :on => :update,
											 :unless => Proc.new { |u| u.password.blank? }
									   																		
	validates :name, :presence => true
	
	validates :display_name, :uniqueness => { :case_sensitive => false },
													 :length => { :maximum => 25 },
													 :allow_blank => true
	
	before_save :encrypt_password, :unless => Proc.new { |u| u.password.blank? }
	
	def has_password?(pass)
		encrypted_password == encrypt(pass)
	end
	
	def get_name
		unless display_name.blank?
			display_name
		else
			name
		end
	end
	
	def get_access_level_name
		if owner?
			'Site owner'
		elsif admin?
			'Administrator'
		elsif member?
			'Member'
		else
			'Viewer'
		end
	end
			
	
	def self.authenticate(submitted_username, submitted_password)
		user = find_by_username(submitted_username)
		user && user.has_password?(submitted_password) ? user : nil
	end
	
	# Access Level Methods
	
	def owner?
		access_level >= 3
	end
	
	def admin? # return true if user is at least an admin
		access_level >= 2
	end
	
	def member? # return true if user is at least a member
		access_level >= 1	
	end	
	
	def make_owner
		self.access_level = 3
		self.save
	end
	
	def make_admin
		self.access_level = 2
		self.save
	end
	
	def make_member
		self.access_level = 1
		self.save
	end
	
	def revoke_rights
		self.access_level = 0
		self.save
	end
	
	private
	
		def encrypt_password
			# ensure that the salt changes whenever the user changes his password
			self.salt = make_salt unless has_password?(password)
			self.encrypted_password = encrypt(password)
		end
		
		def encrypt(string_to_encrypt)
			secure_hash("#{salt}--#{string_to_encrypt}")
		end
		
		def make_salt
			secure_hash("#{Time.now.utc}--#{password}")
		end
		
		def secure_hash(string_to_hash)
			Digest::SHA2.hexdigest(string_to_hash)
		end

end
