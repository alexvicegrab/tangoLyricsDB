module UrlHelper
  def check_url(url)
    
    Rails.logger.warn "UrlHelper::check_url url #{url}"
    uri = URI.parse(url)
    # Domainatrix is better at parsing the path than URI
    uriD = Domainatrix.parse(url)
    response = nil
    
    begin
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.scheme == 'https'
      
      http.start do |http|
        # Changed code to get YouTube to work [broke on uri.path, ignored video code]
        #response = http.head(uri.path.size > 0 ? uri.path : "/")
        response = http.head(uriD.path.size > 0 ? uriD.path : "/")
        Rails.logger.debug "UrlHelper::check_url #{response}"
      end
      
    rescue => e 
      Rails.logger.warn "UrlHelper::check_url error #{e}"
      return nil
    end

    # Handle redirects if you need to
    if response.is_a?(Net::HTTPRedirection)
      if response.code == '303'
        # Necessary for YouTube user redirects
        return true
      else
        return false
      end
    end

    if response.code == '404'
      return false
    end
    #Otherwise...
    return  true
  end
end
