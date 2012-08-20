class Router
  def initialize(&block)
    @routes = []
    ### After routes.rb ###
    instance_eval(&block) if block
    #######################
  end
  
  def match(options)
    path, info = options.first # match({ "/" => 'home#index' })
    controller, action = info.split('#') # 'home#index' => 'home', 'index'
    @routes << [path, [controller, action]]
  end
  
  def recognize(path_info)
    @routes.each do |route|
      path, info = route
      return info if path_info == path
    end
    nil
  end
end