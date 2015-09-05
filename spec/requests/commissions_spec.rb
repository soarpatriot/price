require 'rails_helper'

RSpec.describe "Commissions", :type => :request do
  describe "GET /commissions" do
    it "works! (now write some real specs)" do
      get commissions_path
      expect(response.status).to be(200)
    end
  end
end
