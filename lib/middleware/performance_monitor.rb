module Middleware
  class PerformanceMonitor
    def initialize(app)
      @app = app
    end
    
    def call(env)
      start_time = Time.now
      status, headers, response = @app.call(env)
      
      duration = Time.now - start_time
      Rails.logger.info("Request to #{env['PATH_INFO']} took #{duration.round(2)} seconds")
      
      # Log slow queries
      if duration > 1.0
        Rails.logger.warn("SLOW REQUEST: #{env['PATH_INFO']} took #{duration.round(2)} seconds")
      end
      
      [status, headers, response]
    end
  end
end
