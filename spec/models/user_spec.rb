require 'spec_helper'

describe User do

	before(:each) do
		@attr = {
			:name => 'John Smith',
			:username => 'jsmith',
			:password => 'foobar',
			:password_confirmation => 'foobar'
			}
	end
			
	describe "basic attributes" do
	
		it "should successfully create given valid attributes" do
			User.create!(@attr)
		end
	
		it "should require a name" do
			nameless_user = User.new(@attr.merge(:name => ''))
			nameless_user.should_not be_valid
		end
	
		describe "username" do
	
			it "should be required" do
				no_username = User.new(@attr.merge(:username => ''))
				no_username.should_not be_valid
			end
	
			it "should be unique" do
				User.create!(@attr)
				duplicate_username = User.new(@attr)
				duplicate_username.should_not be_valid
			end
			
			it "should be unique up to case" do
				upcased_username = @attr[:username].upcase
				User.create!(@attr)
				duplicate_username = User.new(@attr.merge(:username => upcased_username))
				duplicate_username.should_not be_valid
			end
			
			it "should be at least 3 characters" do
				short_username = 'aa'
				short_username_user = User.new(@attr.merge(:username => short_username))
				short_username_user.should_not be_valid
			end
			
			it "should be 15 characters or less" do
				long_username = 'a' * 16
				long_username_user = User.new(@attr.merge(:username => long_username))
				long_username_user.should_not be_valid
			end
			
			it "should contain only numbers, letters, and underscores" do
				non_alpha = 'abcd123#sfb'
				non_alpha_user = User.new(@attr.merge(:username => non_alpha))
				non_alpha_user.should_not be_valid
			end
			
			it "should begin with a letter" do
				non_letter = '1abcd123sfb'
				non_letter_user = User.new(@attr.merge(:username => non_letter))
				non_letter_user.should_not be_valid
			end
			
			it "should not end with an underscore" do
				underscore_end = 'aslkie42e_'
				underscore_end_user = User.new(@attr.merge(:username => underscore_end))
				underscore_end_user.should_not be_valid
			end
			
			it "should accept usernames that end with a number" do
				number_end = 'abslkk23'
				number_end_user = User.new(@attr.merge(:username => number_end))
				number_end_user.should be_valid
			end
		
		end
	
		describe "password" do

    	it "should be required" do
      	User.new(@attr.merge(:password => "", :password_confirmation => "")).
        should_not be_valid
    	end

    	it "should require a matching password confirmation" do
      	User.new(@attr.merge(:password_confirmation => "invalid")).
        should_not be_valid
    	end

    	it "should be at least 6 characters" do
      	short = "a" * 5
      	hash = @attr.merge(:password => short, :password_confirmation => short)
      	User.new(hash).should_not be_valid
    	end

   		it "should be less than 40 characters" do
      	long = "a" * 41
      	hash = @attr.merge(:password => long, :password_confirmation => long)
     	  User.new(hash).should_not be_valid
   	  end
   	  
   	  describe "password encryption" do
   	  	
   	  	before(:each) do
   	  		@user = User.create!(@attr)
   	  	end
   	  	
   	  	it "should have an encrypted password" do
   	  		@user.should respond_to(:encrypted_password)
   	  	end  
   	  	
   	  	it "should set the encrypted password in the database" do
      		@user.encrypted_password.should_not be_blank
   			end 
   			
   			describe "has_password?" do
   			
   				it "should return true if the passwords match" do
   					@user.has_password?(@attr[:password]).should be_true
   				end
   				
   				it "should return false if the passwords don't match" do
   					@user.has_password?('invalidpass').should_not be_true
   				end
   			
   			end	  	
   	  	
   	  end
    
 	  end	
 	  
 	  describe "display name" do
 	  
 	  	before(:each) do
 	  		@attr = @attr.merge(:display_name => 'J. Smith')
 	  		@user = User.create!(@attr)
 	  	end	
			
			it "should be unique" do
				same_display_name = User.new(@attr.merge(:username => 'jfsmith'))
				same_display_name.should_not be_valid
			end
			
			it "should accept only letters, numbers, underscores, periods, spaces" do
				invalid = User.new(@attr.merge(:username => 'jfsmith', :display_name => 'abcdef#g'))
				invalid.should_not be_valid
			end
		
		end
  	
  end
  
  describe "access_level attribute" do
  	
  	before(:each) do
  		@user = User.create(@attr)
  	end
  	
  	it "should exist" do
  		@user.should respond_to(:access_level)
  	end
  	
  	it "should be 0 by default" do
  		@user.access_level.should == 0
  	end
  	
  	it "should not be a member by default" do
  		@user.should_not be_member
  	end
  	
  	it "should not be an admin by default" do
  		@user.should_not be_admin
  	end
  	
  	it "should be a member if access level = 1" do
  		@user.access_level = 1
  		@user.should be_member
  	end
  	
  	it "should be a member if access level > 1" do
  		@user.access_level = 2
  		@user.should be_member
  	end
  	
  	it "should be an admin if access level >= 2" do
  		@user.access_level = 2
  		@user.should be_admin
  	end
	
	end  		

end
