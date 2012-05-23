require 'spec_helper'

describe PagesController do

  describe "GET 'home'" do
    
    it "should require signin" do
    	get :home
    	response.should redirect_to signin_path
    end
    
  end

  describe "GET 'blog'" do
   
    it "should require signin" do
    	get :blog
    	response.should redirect_to signin_path
   
    end
  end

end
