# frozen_string_literal: true

json.(image, :id, :position, :attachment_content_type, :attachment_file_name, :type, :attachment_updated_at, :attachment_width, :attachment_height, :alt)
json.(image, :viewable_type, :viewable_id)
Spree::Image.attachment_definitions[:attachment][:styles].each do |k, _v|
  json.set! "#{k}_url", image.attachment.url(k)
end
