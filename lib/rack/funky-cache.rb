require 'fileutils'
require 'rack'

module Rack

  class FunkyCache
    
    def initialize(app, settings)
      @app = app       
      @settings = settings
    end

    def call(env)
      response = @app.call(env)
      cache(env, response) if should_cache(env, response)
      response
    end
    
    def cache(env, response)
      path = Rack::Utils.unescape(env["PATH_INFO"])
            
      if path[-1, 1] == "/"
        path = ::File.join(path, "index.html")
      else
        path << '.html'         
      end      
        
      basename  = ::File.basename(path)
      dirname   = ::File.join(@settings[:directory], ::File.dirname(path))
      cachefile = ::File.join(dirname, basename)

      FileUtils.mkdir_p(dirname) unless ::File.directory?(dirname)
      ::File.open(cachefile, "w") do |file|
        response[2].each do |string| 
          file.write(string)
        end
      end
    end
    
    def should_cache(env, response)
      "text/html" == response[1]['Content-Type'] and 200 == response[0]
    end
    
  end
end
