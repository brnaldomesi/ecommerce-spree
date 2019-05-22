
def make_product_spec_factories(name, value_type, values)
  values.each do|c|
    factory "product_spec_#{name.underscore.downcase}_#{c.to_s.underscore.downcase}".to_sym do
      value_type { value_type }
      name { name }
      value_1 { c }
    end
  end
end

FactoryBot.define do

  factory :product_spec, class: Retail::ProductSpec do

    make_product_spec_factories 'colors', 'String', %w|white black red green blue silver gray|

    make_product_spec_factories 'gender', 'String', %w|male female|

    make_product_spec_factories 'brand', 'String', ['Nike', 'Calvin Klein', 'Levis', 'Sony', 'HP', 'Apple', 'Nintendo']

    make_product_spec_factories 'size', 'String', %w|xs s m l xl|

    make_product_spec_factories 'material', 'String', %w|plastic steel aluminum cotton silk leather|

    make_product_spec_factories 'length', 'Integer', %w|1 2 3 4 5 6 7 8 9 10 11 12 13 14 15|

  end
end