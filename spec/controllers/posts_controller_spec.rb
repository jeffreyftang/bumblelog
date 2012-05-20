require 'spec_helper'

describe PostsController do

  describe "GET 'new'" do
  
  	before(:each) do
  		@user = Factory(:user)
  	end
  
  	it "should require user to be logged in" do
  		get 'new'
  		response.should redirect_to signin_path
  	end
  
    it "should restrict access to member-level users only" do
    	controller.sign_in(@user)
      get 'new'
      response.should redirect_to root_path
    end
    
    describe "for logged in members and above" do
    	
    	before(:each) do
    		@user.make_member
    		controller.sign_in(@user)
    	end
    
    	it "should be successful" do
    		get :new
    		response.should be_success
    	end
    
    end
        
  end

  describe "GET 'edit'" do

  end

  describe "GET 'show'" do
   
  end

  describe "GET 'index'" do
    
  end

end
