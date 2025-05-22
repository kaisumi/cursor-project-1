require 'rack/attack'

class Rack::Attack
  # Throttle login attempts
  throttle('req/ip/login', limit: 5, period: 20.seconds) do |req|
    req.ip if req.path == '/auth/login' && req.post?
  end

  # Throttle API requests
  throttle('req/ip/api', limit: 30, period: 60.seconds) do |req|
    req.ip if req.path.start_with?('/api/')
  end

  # Ban suspicious activity
  blocklist('fail2ban') do |req|
    Rack::Attack::Fail2Ban.filter("pentest-#{req.ip}", maxretry: 3, findtime: 10.minutes, bantime: 1.hour) do
      req.path.include?('/wp-login') || req.path.include?('/administrator/')
    end
  end

  # Allow localhost
  safelist('allow from localhost') do |req|
    req.ip == '127.0.0.1' || req.ip == '::1'
  end

  # Configure response
  self.throttled_response = lambda do |env|
    [ 429, # status
      { 'Content-Type' => 'application/json' }, # headers
      [{ error: 'Too many requests. Please try again later.' }.to_json] # body
    ]
  end
end
