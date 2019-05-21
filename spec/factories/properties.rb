FactoryBot.define do
  factory :properties, class: Spree::Property do
    %w|Brand Port Gender Size Material|.each do|p|
      factory "#{p.underscore.downcase}_property".to_sym do
        name { p }
        presentation { p }
      end
    end
  end
end