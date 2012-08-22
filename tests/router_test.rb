require File.dirname(__FILE__) + '/test_helper'
require "router"

class RouterTest < Test::Unit::TestCase
  def test_match_simple_route
    router = Router.new
    router.match '/' => 'home#index'
    assert_equal ['home', 'index'], router.recognize('/')
    assert_equal nil, router.recognize('/a')
  end
  
  def test_dsl
    router = Router.new do
      match '/' => 'home#index'
    end
    assert_equal ['home', 'index'], router.recognize('/')
  end
end