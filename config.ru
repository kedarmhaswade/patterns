class App
  def call(env)
    [
      200,
      { "Content-Type" => "text/plain" },
      [env["PATH_INFO"]]
    ]
  end
end

class Logger
  def initialize(app)
    @app = app
  end
  
  def call(env)
    puts "Calling " + env["PATH_INFO"]
    @app.call(env)
  end
end

class Upcase
  def initialize(app)
    @app = app
  end
  
  def call(env)
    status, headers, body = @app.call(env)
    body.each { |s| s.upcase! }
    [status, headers, body]
  end
end

use Logger
use Upcase

run App.new