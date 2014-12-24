require 'rails_helper'

RSpec.describe "UserProfiles", :type => :request do
  describe "GET /user_profiles" do
    it "works! (now write some real specs)" do
      get user_profiles_path
      expect(response).to have_http_status(200)
    end
  end
end
