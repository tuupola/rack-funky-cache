require 'test_helper'

class RackFunkyCacheTest < Test::Unit::TestCase
  include Rack::Test::Methods
  
  def app
      lambda { |env| [200, {}, "Coolness"] }
  end
  
  should "return some coolness" do
    get "/"
    assert last_response.body.include?("Cool")
  end

  context "A User instance" do
  end
  
end
