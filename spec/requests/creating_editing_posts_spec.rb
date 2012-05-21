require 'spec_helper'

describe "CreatingEditingPosts" do

	before(:each) do
		user = Factory(:user)
		visit signin_path
		fill_in :username, :with => user.username
		fill_in :password, :with => user.password
		click_button
	end

  describe "saving a new draft" do
  	
  	it "should create a new draft" do
  		lambda do
  			visit new_post_path
  			fill_in 'post[title]', :with => 'The Title'
  			fill_in 'post[content]', :with => 'The brilliant content here.'
  			click_button 'Save as draft'
  		end.should change(Post, :count).by(1)
   	end
   
  end
  
end
