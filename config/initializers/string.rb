class String < Object
  ##
  # Use when write to IO stream is broken w/ exception like "Encoding::UndefinedConversionError: "\xE2" from ASCII-8BIT to UTF-8"
  def encode_to_utf8
    self.encode 'UTF-8', invalid: :replace, undef: :replace, replace: '?'
  end

  def uri
    URI(self)
  end

  def to_keyword_name
    self.class.sanitize_keyword_name(self)
  end

  def valid_keyword_name?
    self.class.valid_keyword_name?(self)
  end

  def to_sanitized_keyword_name
    self.class.sanitize_keyword_name(self)
  end

  REDUNDANT_PREFIXES_REGEX = /^(a|available|about|applicable|appropriate|choose|chosen|for|get|with|the|suggeste?d?|product|item)\b/i

  def self.sanitize_keyword_name(name = '')
    name.gsub(REDUNDANT_PREFIXES_REGEX, '').split(':').first.to_s.gsub(/([()\[\],"]+)/, '').squeeze.strip
  end

end
