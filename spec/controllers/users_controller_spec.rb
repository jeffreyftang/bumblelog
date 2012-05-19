require 'spec_helper'

describe UsersController do

	render_views

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

  describe "PUT 'edit'" do
  
  	before(:each) do
			@user = Factory(:user)
		end
  
    it "should be successful" do
      put 'edit', :id => @user
      response.should be_success
    end
    
  end

  describe "GET 'show'" do
  
  	before(:each) do
			@user = Factory(:user)
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
