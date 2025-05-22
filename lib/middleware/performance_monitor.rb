module Middleware
  class PerformanceMonitor
    class << self
      attr_accessor :error_reporter
    end
    
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
        
        # Report to error tracking service if configured
        if self.class.error_reporter.respond_to?(:call)
          self.class.error_reporter.call(env['PATH_INFO'], duration, nil)
        end
      end
      
      [status, headers, response]
    end
  end
end
