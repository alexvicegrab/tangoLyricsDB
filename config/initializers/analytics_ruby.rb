Analytics = AnalyticsRuby       # Alias for convenience

if (Rails.env.development? || Rails.env.test?)
  writeKey = 'hubhr5p05d'
elsif (Rails.env.production?)
  writeKey = '4ueehdp3k9'
end

Analytics.init({
    secret: writeKey,          # The write key for alejandrovicentegrabovetsky/tangotranslation
    on_error: Proc.new { |status, msg| print msg }  # Optional error handler
})