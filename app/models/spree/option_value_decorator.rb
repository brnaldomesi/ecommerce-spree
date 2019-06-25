module Spree
  OptionValue.class_eval do
    scope :with_names, lambda {|option_type_names|
        joins(:option_type).where("#{Spree::OptionType.table_name}.name IN (?)", option_type_names ) }

    def option_type_name
      option_type.name
    end
  end
end