require 'spec_helper'

describe "CreatingEditingPosts" do

	before(:each) do
		user = Factory(:user)
		user.make_member
		visit signin_path
		fill_in 'session[username]', :with => user.username
		fill_in 'session[password]', :with => user.password
		click_button
	end

  describe "saving a new draft" do
  	
  	it "should create a new draft" do
  		lambda do
  			visit new_post_path
  			fill_in :title, :with => 'The Title'
  			fill_in :content, :with => 'The brilliant content here.'
  			click_button 'Save as draft'
  			post = Post.find_by_title('The Title')
  			post.should_not be_nil
  			lambda do
  				visit post_path(post)
  			end.should raise_error
  		end.should change(Post, :count).by(1)
  	end
   
  end
  
  describe "publishing a new post" do
  	
  	it "should create a new draft" do
  		lambda do
  			visit new_post_path
  			fill_in :title, :with => 'The Title'
  			fill_in :content, :with => 'The brilliant content here.'
  			click_button 'Publish'
  			post = Post.find_by_title('The Title')
  			post.should_not be_nil
  			visit post_path(post)
  			response.should have_selector('h1', :content => post.title)
  		end.should change(Post, :count).by(1)
  	end
  	
  end
    
end
