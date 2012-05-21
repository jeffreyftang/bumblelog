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
		
		it "should require a title" do
			post = @user.posts.build(@attr.merge(:title => ''))
			post.should_not be_valid
		end
		
		it "should require content" do
			post = @user.posts.build(@attr.merge(:content => ''))
			post.should_not be_valid
		end
		
		it "should have an author" do
			post = Post.new(@attr)
			post.should_not be_valid
		end
	
		describe "post order" do
	
			before(:each) do
				@post1 = Factory(:post, :user => @user, :created_at => 1.day.ago, :published_at => 1.hour.ago)
				@post2 = Factory(:post, :user => @user, :slug => 'the-new-slug', :created_at => 1.hour.ago, :published_at => 1.day.ago)
			end
	
			it "should have the posts in the right order" do
				Post.all.should == [@post1, @post2]
			end
	
		end
	
	end	
	
end
