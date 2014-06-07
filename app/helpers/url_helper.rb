module UrlHelper
  def check_url(url)
    uri = URI.parse(url)
    response = nil

    begin
      Net::HTTP.start(uri.host, uri.port) do |http|
        response = http.head(uri.path.size > 0 ? uri.path : "/")
        Rails.logger.debug "UrlHelper::check_url #{response}"
      end
    rescue => e 
      Rails.logger.warn "UrlHelper::check_url error #{e}"
      return false
    end

    # Handle redirects if you need to
    if response.is_a?(Net::HTTPRedirection)
      return false
    end

    if response.code == '404'
      return false
    end
    #Otherwise...
    return  true
  end
end