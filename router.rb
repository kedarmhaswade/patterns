class Router
  def initialize(&block)
    @routes = {}
    instance_eval(&block) if block
  end
  
  def match(options)
    path, action = options.first # match "/" => 'home#index'
    @routes[path] = action.split('#') # ['home', 'index']
  end
  
  def recognize(path_info)
    @routes[path_info]
  end
end

######### routes.rb ##########
Routes = Router.new do
  match '/' => 'home#index'
  match '/yo' => 'home#index'
  match '/users' => 'users#index'
end