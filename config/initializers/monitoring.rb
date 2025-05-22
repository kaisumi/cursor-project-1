# Sentry Configuration
Sentry.init do |config|
  config.dsn = ENV['SENTRY_DSN']
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]
  config.traces_sample_rate = 0.5
  
  # Only send errors in production
  config.enabled_environments = %w[production staging]
  
  # Add context to events
  config.before_send = lambda do |event, hint|
    # Skip certain errors
    return nil if hint[:exception].is_a?(ActionController::RoutingError)
    
    event
  end
end

# Custom performance monitoring
Rails.application.config.after_initialize do
  # Register Sentry as error reporter for PerformanceMonitor
  Middleware::PerformanceMonitor.error_reporter = lambda do |path, duration, error|
    Sentry.capture_message(
      "Slow request: #{path} took #{duration.round(2)}s",
      level: 'warning',
      extra: { path: path, duration: duration }
    )
  end
end
