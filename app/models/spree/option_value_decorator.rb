module Spree
  OptionValue.class_eval do

    attr_accessor :variant_ids

    scope :with_names, lambda {|option_type_names|
        joins(:option_type).where("#{Spree::OptionType.table_name}.name IN (?)", option_type_names ) }
    scope :single_names, -> { where("name NOT LIKE '%/%' AND name NOT LIKE '% %'") }
    scope :multi_word_names, -> { where("name LIKE '%/%' OR name LIKE '% %'") }

    def option_type_name
      option_type.name
    end
  end
end