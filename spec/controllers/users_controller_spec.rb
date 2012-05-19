require 'spec_helper'

describe UsersController do

	render_views

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'edit'" do
  
  	before(:each) do
			@user = Factory(:user)
		end
  
    describe "for non-signed-in users" do
    
    	it "should deny access" do
    		get :edit, :id => @user
    		flash[:notice].should =~ /please sign in/i
    		response.should redirect_to(signin_path)
    	end
    	
    end
    
    describe "for signed-in users" do
    	
    	before(:each) do
    		@wrong_user = Factory(:user, :username => Factory.next(:username), :display_name => Factory.next(:display_name))
    	end
    	
    	it "should deny access except to the right user" do
    		controller.sign_in(@wrong_user)
    		get :edit, :id => @user
    		response.should redirect_to(root_path)
    	end
    	
    end	
    
  end
  
  describe "PUT 'update'" do
  
  	before(:each) do 
  		@attr = { :name => 'New Name', :username => 'newusername', :password => 'newpass', :password_confirmation => 'newpass' }
  		@user = Factory(:user)
  	end
  
  	describe "for non-signed-in users" do
  	
  		it "should deny access" do
  			put :update, :id => @user, :user => @attr
  			flash[:notice].should =~ /please sign in/i
  			response.should redirect_to(signin_path)
  		end
  	
  	end
  	
  	describe "for signed-in users" do
  		
  		before(:each) do
    		@wrong_user = Factory(:user, :username => Factory.next(:username), :display_name => Factory.next(:display_name))
    	end
    	
    	it "should deny access except to the right user" do
    		controller.sign_in(@wrong_user)
    		put :update, :id => @user, :user => @attr
    		response.should redirect_to(root_path)
    	end
    	
    	it "should change the user's attributes" do
    		controller.sign_in(@user)
    		put :update, :id => @user, :user => @attr
    		@user.reload
    		@user.name.should == @attr[:name]
    		@user.username.should == @attr[:username]
    	end
    
    end
  	
  end

  describe "GET 'show'" do
  
  	before(:each) do
			@user = Factory(:user)
		end
		
		describe "for non-signed-in users" do
		
			it "should deny access" do
				get :show, :id => @user
				response.should redirect_to(signin_path)
			end
			
		end
		
		describe "for signed-in users" do
		
			before(:each) do
				controller.sign_in(@user)
			end
  
  	  it "should be successful" do
    	  get 'show', :id => @user
      	response.should be_success
   	 end
    
    	it "should have h1 with the user's display name" do
    		get 'show', :id => @user
    		response.should have_selector("h1", :content => @user.display_name)
    	end
    
   	 it "should have h1 with the user's name if there's no display name" do
    		no_display_name_user = Factory(:user, :display_name => '', :username => Factory.next(:username))
	    	get 'show', :id => no_display_name_user
  	  	response.should have_selector("h1", :content => no_display_name_user.name)
  		end
  		
  	end    	 
    
  end

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end
  
  describe "POST 'create'" do
  	
  	describe "failed signup" do
  	
  		before(:each) do
  			@attr = { :username => '', :name => '', :password => '', :password_confirmation => '' }
  		end
  	
  		it "should not create a new user in the database" do
  			lambda do
  				post :create, :user => @attr
  			end.should_not change(User, :count)
  		end
  	
 		 	it "should render the 'new' template" do
  			post :create, :user => @attr
  			response.should render_template('new')
  		end
  		
  	end
  	
  	describe "successful signup" do
  		
  		before(:each) do
  			@attr = { :username => 'jsmith', :name => "John Smith", :password => 'foobar', :password_confirmation => 'foobar' }
  		end
  		
  		it "should create a new user" do
  			lambda do
  				post :create, :user => @attr
  			end.should change(User, :count).by(1)
  		end
  		
  		it "should redirect to the user show page" do
  			post :create, :user => @attr
  			response.should redirect_to(user_path(assigns(:user)))
  		end
  			
  	end
  	
  end	

end
