SecureHeaders::Configuration.default do |config|
  config.x_frame_options = "DENY"
  config.x_content_type_options = "nosniff"
  config.x_xss_protection = "1; mode=block"
  config.x_download_options = "noopen"
  config.x_permitted_cross_domain_policies = "none"
  config.referrer_policy = %w(origin-when-cross-origin strict-origin-when-cross-origin)
  
  # Content Security Policy
  config.csp = {
    default_src: %w('self'),
    script_src: %w('self' 'unsafe-inline'),
    style_src: %w('self' 'unsafe-inline'),
    img_src: %w('self' data:),
    connect_src: %w('self' ws: wss:),
    font_src: %w('self'),
    object_src: %w('none'),
    child_src: %w('self'),
    frame_ancestors: %w('none'),
    form_action: %w('self'),
    base_uri: %w('self'),
    block_all_mixed_content: true
  }
end
