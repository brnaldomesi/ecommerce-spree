class URI::Generic

  DOMAIN_BASE_REGEX = /[^.]+\.[^.]{3}((\.[a-z]{2})+)?(:\d+)?$/

  # Excludes subdomain such as 'www.' in 'www.ioffer.com'.  This includes port number at default if not 80.
  def self.domain_base(url, include_port = true)
    full_url = url
    full_url.insert(0, 'http://') unless full_url =~ /^(ht|f)tps?:\/\//
    uri = URI(full_url)
    s = uri.host.match(DOMAIN_BASE_REGEX).try(:[], 0) || uri.host
    s += ":#{uri.port}" if include_port && uri.port && uri.port != 80
    s
  end

  def uri
    self
  end

  ##
  # @cgi_escaping <Boolean> whether should unescape values of the parameters; default true.
  #   This would helpful to skip useless back and forth escaping and unescaping.
  # @return <ActiveSupport::HashWithIndifferentAccess>
  def sorted_parameters(cgi_escaping = true)
    h = ::ActiveSupport::HashWithIndifferentAccess.new
    query.to_s.split('&').sort.each do|pair_s|
      parts = pair_s.split('=')
      k = parts[0]
      v = cgi_escaping && parts[1] ? CGI.unescape(parts[1]) : parts[1].to_s
      if k && k.ends_with?('[]')
        k2 = k.gsub(/(\[\])$/, '')
        if list = h[ k2 ]
          list << v
          h[ k2 ] = list.sort!
        else
          h[ k2 ] = [v]
        end
      else
        h[ k ] = v
      end
    end
    h
  end

  ##
  # In the use of sorted_parameters, passes on cgi_escaping.
  # @cgi_escaping <Boolean> whether should escape values of the paramters in query string; default true.
  # @return <String>
  def sorted_query(cgi_escaping = true)
    q = ''
    sorted_parameters(cgi_escaping).each_pair do|k,v|
      if v.is_a?(Enumerable)
        v.each do|v2|
          q << '&' unless q == ''
          q << k + '[]=' + (cgi_escaping ? CGI.escape(v2) : v2)
        end
      else
        q << '&' unless q == ''
        q << k + '=' + (cgi_escaping && v ? CGI.escape(v) : v.to_s)
      end
    end
    q
  end

  ##
  # Instead of simple request_uri, combines the ending parts of URI:
  # path+query, where query would be parsed and sorted for consistent order for same parameters.
  # @return <String>
  def sorted_request_uri
    s = path
    if query.present?
      s << '?' + sorted_query(false) # query itself already escaped
    end
    s
  end
end