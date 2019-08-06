module Spree
  OptionType.class_eval do
    validate :check_name

    VALID_OPTION_NAME_REGEX = /^((max|maximum|minmum|min|average|avg|estimate|est|US|UK|original|market|man'?s?|men'?s?|woman'?s?|women'?s?|kids?|adults?|new|supported|product|item)\s+)?([a-z]{2,}\s+)?(types?|category|name|colou?rs?|sizes?|number|no|sku|brand|width|length|height|diameter|radius|thickness|area|waist|bust|collar|weight|depth|models?|material|fabric|quality|quantity|count|pieces?|style|group|range|age|gender|level|class|capacity|time|date|life|season|quantity|version|edition|mode|port|payment|pattern|price|cost|charge|fee|rate|frequency|response|speed|bandwidth|volume|shape|method|current|voltage|percentage|ratio|frequency|condition|code|sleeve|sensitivity|grade|rating|platform|protocol|operating\s+system|format|angle|interface|standard)$/i

    DEFAULT_CACHE_KEY = 'DEFAULT_OPTION_TYPES'

    after_save :clear_cache

    def self.valid_option_name?(name = '')
      !name.to_sanitized_keyword_name.match(VALID_OPTION_NAME_REGEX).nil?
    end

    def self.default_option_types(category_names = [])
      self.where(name: ['color', 'clothing color', 'size', 'clothing size', 'shoe size'] )
    end

    protected

    def check_name
      unless self.class.valid_option_name?(name)
        self.errors.add(:name)
      end
    end

    def clear_cache
      Rails.cache.delete(DEFAULT_CACHE_KEY)
    end
  end
end