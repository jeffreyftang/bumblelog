require 'spec_helper'

describe SessionsController do

	render_views

  describe "GET 'new'" do
  
    it "should be successful" do
      get 'new'
      response.should be_success
    end
    
  end
  
  describe "POST 'create'" do
  
  	describe "failure" do
  	
  		before(:each) do
  			@attr = { :username => 'username', :password => 'invalid' }
  		end
  	
  		it "should render the new page" do
  			post :create, :session => @attr
  			response.should render_template('new')
  		end
  		
  		it "should have a flash.now message" do
  			post :create, :session => @attr
  			flash.now[:error].should =~ /invalid/i
  		end
  	
  	end
  	
  	describe "success" do
  	
  		before(:each) do
  			@user = Factory(:user)
  			@credentials = { :username => @user.username, :password => @user.password }
  		end
  		
  		it "should sign the user in" do
  			post :create, :session => @credentials
  			controller.current_user.should == @user
  			controller.should be_signed_in
  		end
  		
  		it "should redirect to the user show page" do
  			post :create, :session => @credentials
  			response.should redirect_to(user_path(@user))
  		end
  	
  	end
  	
  end  			

end