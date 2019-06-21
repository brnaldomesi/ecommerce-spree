module Spree
  OptionType.class_eval do
    validate :check_name

    VALID_OPTION_NAME_REGEX = /^((max|maximum|minmum|min|average|avg|estimate|est|US|UK|original|market|man'?s?|men'?s?|woman'?s?|women'?s?|kids?|adults?|new|supported|product|item)\s+)?([a-z]{2,}\s+)?(types?|category|name|colou?rs?|sizes?|number|no|sku|brand|width|length|height|diameter|radius|thickness|area|waist|bust|collar|weight|depth|models?|material|fabric|quality|quantity|count|pieces?|style|group|range|age|gender|level|class|capacity|time|date|life|season|quantity|version|edition|mode|port|payment|pattern|price|cost|charge|fee|rate|frequency|response|speed|bandwidth|volume|shape|method|current|voltage|percentage|ratio|frequency|condition|code|sleeve|sensitivity|grade|rating|platform|protocol|operating\s+system|format|angle|interface|standard)$/i

    def self.valid_option_name?(name)
      !sanitize_keyword_name(name).match(VALID_OPTION_NAME_REGEX).nil?
    end

    protected

    def check_name
      unless name.valid_option_name?
        self.errors.add(:name)
      end
    end
  end
end