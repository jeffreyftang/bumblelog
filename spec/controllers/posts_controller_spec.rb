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
  
  describe "POST 'create'" do
  
  	before(:each) do
  		@user = Factory(:user)
  		@attr = { :title => 'Hello World!', :content => 'This is your post.' }
  	end
  
  	describe "for signed-in members" do
  	
  		before(:each) do
  			@user.make_member
  			controller.sign_in(@user)
  		end
  
  		it "should create the post" do
  			lambda do
  				post :create, :post => @attr
  			end.should change(Post, :count).by(1)
  		end  			
  		
  	end
  
  end

  describe "GET 'edit'" do
  
  	before(:each) do
  		@user = Factory(:user)
  		@user.make_member
  		@wrong_user = Factory(:user, :username => 'myname', :display_name => 'My Name')
  		@wrong_user.make_member
  		@post = Factory(:post, :user => @user)
  	end
  
  	it "should deny access to wrong users" do		
  		controller.sign_in(@wrong_user)
  		get :edit, :id => @post
  		response.should redirect_to root_path
  	end
  	
  	it "should allow access by admin users" do
  		controller.sign_in(@wrong_user)
  		@wrong_user.make_admin
  		get :edit, :id => @post
  		response.should be_success		
		end
		
		it "should allow access by the correct user" do
		  controller.sign_in(@user)
  		get :edit, :id => @post
  		response.should be_success 
  	end

  end
  
  describe "PUT 'update'" do
  
  	before(:each) do
  		@user = Factory(:user)
  		@user.make_member
  		@wrong_user = Factory(:user, :username => 'myname', :display_name => 'My Name')
  		@wrong_user.make_member
  		@post = Factory(:post, :user => @user)
  		@attr = { :title => 'New title', :content => 'New content' }
  	end
  
  	it "should require login" do
  		put :update, :id => @post, :post => @attr
  		response.should redirect_to signin_path
  	end
  	
  	it "should deny access to wrong users" do
  		controller.sign_in(@wrong_user)
  		put :update, :id => @post, :post => @attr
  		response.should redirect_to root_path
  	end
  	
  	it "should allow access by admin users" do
  		controller.sign_in(@wrong_user)
  		@wrong_user.make_admin
  		put :update, :id => @post, :post => @attr
  		response.should redirect_to edit_post_path(@post)
  	end
  		
  	it "should allow access to the right user" do 	
  		controller.sign_in(@user)
  		put :update, :id => @post, :post => @attr
  		response.should redirect_to edit_post_path(@post) 				
		end
		
		describe "success" do
		
			it "should change the post's attributes" do
				controller.sign_in(@user)
				put :update, :id => @post, :post => @attr
				@post.reload
				@post.title.should == @attr[:title]
				@post.content.should == @attr[:content]
			end

		end 
  	 
  end

  describe "GET 'show'" do
  
  	before(:each) do
  		@user = Factory(:user)
  		@post = Factory(:post, :user => @user, :published => true)
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
  		
  		describe "showing draft posts" do
  		
  			it "should not allow access" do
  				@post.unpublish
  				lambda do
  					get :show, :id => @post
  				end.should raise_error
  			end
  			
  		end
  		
  	end
   
  end
  
  describe "DELETE 'destroy'" do
  	
  	before(:each) do
  		@user = Factory(:user)
  		@user.make_member
  		@post = Factory(:post, :user => @user)
  		@wrong_user = Factory(:user, :username => 'myusername', :display_name => '')
  		@wrong_user.make_member
  	end
  	
  	it "should deny access to the wrong user and not delete the post" do
  		controller.sign_in(@wrong_user)
  		lambda do
  			delete :destroy, :id => @post
  			response.should redirect_to root_path
  		end.should_not change(Post, :count)
  	end
  	
  	describe "if user is correct user or admin" do
  	
  		it "should delete the post if the user is the correct user" do
  			@controller.sign_in(@user)
  			lambda do
  				delete :destroy, :id => @post
  			end.should change(Post, :count).by(-1)
  			Post.find_by_id(@post).should be_nil
  		end
  		
  		it "should delete the post if the user is an admin" do
  			@controller.sign_in(@wrong_user)
  			@wrong_user.make_admin
  			lambda do
  				delete :destroy, :id => @post
  			end.should change(Post, :count).by(-1)
  			Post.find_by_id(@post).should be_nil
  		end
  		
  	end
  	  
  end  		

end
