require 'spec_helper'

describe PostsController do

	render_views

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
  
  	before(:each) do
  		@user = Factory(:user)
  		@post = Factory(:post, :user => @user)
  	end
  	
  	it "should deny access for non-logged-in users" do
  		get :show, :id => @post
  		response.should redirect_to signin_path
  	end
  	
  	describe "for logged in users" do
  	
  		before(:each) do
  			controller.sign_in(@user)
  		end
  	
  		it "should be successful" do
  			get :show, :id => @post
  			response.should be_success
  		end
  		
  		it "should show the post" do
  			get :show, :id => @post
  			response.should have_selector('h1', :content => @post.title)
  			response.should have_selector('div#post_content', :content => @post.content)
  		end 
  		
  	end
   
  end

  describe "GET 'index'" do
    
  end

end
