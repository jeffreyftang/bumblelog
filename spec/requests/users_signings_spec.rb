require 'spec_helper'

describe "UsersSignings" do
  
  describe "signup" do
  
  	describe "failure" do
  	
  		it "should not make a new user" do
  			lambda do
  				visit signup_path
  				fill_in 'user[name]', :with => ''
  				fill_in 'user[username]', :with => ''
  				fill_in 'user[password]', :with => ''
  				fill_in 'user[password_confirmation]', :with => ''
  				click_button
  				response.should render_template('users/new')
  				response.should have_selector('div#error_list')
  			end.should_not change(User, :count)
  		end
  	
  	end
  	
  	describe "success" do
  		
  		it "should create a new user with the given attributes" do
  			lambda do
  				visit signup_path
  				fill_in 'user[name]', :with => 'Tom Jones'
  				fill_in 'user[username]', :with => 'tjones'
  				fill_in 'user[password]', :with => 'password'
  				fill_in 'user[password_confirmation]', :with => 'password'
  				click_button
  				response.should render_template('users/show')
  				response.should have_selector('title', :content => 'Tom Jones')
  			end.should change(User, :count).by(1)
  		end
  	
  	end
  	
  end
  
end
