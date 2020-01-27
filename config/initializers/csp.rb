SecureHeaders::Configuration.default do |config|
  config.csp = {
    default_src: %w('none'), # nothing allowed by default
    script_src: %w('self' 'unsafe-inline'),
    connect_src: %w('self'),
    img_src: %w('self' data:),
    font_src: %w('self' data:),
    base_uri: %w('self'),
    style_src: %w('self' 'unsafe-inline'),
    form_action: %w('self')
    #report_uri: %w(/mgmt/csp_reports)
  }
end
