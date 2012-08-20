require File.dirname(__FILE__) + '/test_helper'
require "router"

class RouterTest < Test::Unit::TestCase
  def setup
    @router = Router.new
  end
  
  def test_match_simple_route
    @router.match '/' => 'home#index'
    assert_equal ['home', 'index'], @router.recognize('/')
    assert_equal nil, @router.recognize('/a')
  end
end