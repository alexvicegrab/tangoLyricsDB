Analytics = AnalyticsRuby       # Alias for convenience
Analytics.init({
    secret: '4ueehdp3k9',          # The write key for alejandrovicentegrabovetsky/tangotranslation
    on_error: Proc.new { |status, msg| print msg }  # Optional error handler
})