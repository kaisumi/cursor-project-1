Rails.application.configure do
  config.lograge.enabled = true
  config.lograge.custom_options = lambda do |event|
    {
      request_id: event.payload[:request_id],
      user_id: event.payload[:user_id],
      remote_ip: event.payload[:remote_ip],
      params: event.payload[:params].except(*Rails.application.config.filter_parameters)
    }
  end
end
