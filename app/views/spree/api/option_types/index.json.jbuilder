json.array! @option_types do |option_type|
  json.partial!('spree/api/option_types/option_type', option_type: option_type,
                option_type_attributes: [:id, :name, :presentation, :position],
                option_value_attributes: [:id, :name, :presentation, :option_type_name, :option_type_id, :option_type_presentation]
  )
end