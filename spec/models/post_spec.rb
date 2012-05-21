require 'spec_helper'

describe Post do

	describe "basic attributes" do
	
		before(:each) do
			@user = Factory(:user)
			@user.make_member
			@attr = { :title => 'Hello World!', 
								:content => 'The quick brown fox jumped over the lazy dogs'
							}
		end
	
		it "should create an instance given valid attributes" do
			lambda do
				@user.posts.create!(@attr)
			end.should change(Post, :count).by(1)
		end
		
#		it "should require a title" do
#			post = @user.posts.build(@attr.merge(:title => ''))
#			post.should_not be_valid
#		end
#		
#		it "should require content" do
#			post = @user.posts.build(@attr.merge(: => ''))
#			post.should_not be_valid
#		end
		
		it "should have an author" do
			post = Post.new(@attr)
			post.should_not be_valid
		end
	
	end
	
	describe "draft/published status"
	
	describe "slug"
	
end
