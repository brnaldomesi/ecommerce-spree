class ImageUploader < CarrierWave::Uploader::Base

  include ::CarrierWave::RMagick

  MAX_WIDTH = 3000
  MAX_HEIGHT = 3000

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  process :resize_to_limit => [MAX_WIDTH, MAX_HEIGHT]
  process :store_dimensions


  # Create different versions of your uploaded files:
  version :thumb do
    process :resize_to_limit => [360, 360]
  end

  def model_id_path
    padded_id = '%09d' % [model.id]
    subfolder_path = ''
    0.upto(padded_id.size - 1) do|i|
      subfolder_path << '/' if i > 0 && i % 3 == 0
      subfolder_path << padded_id[i]
    end
    subfolder_path
  end


  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    # sub_folders = sprintf('%06d', model.id).split(/([\d]{3})/).delete_if(&:blank?)
    affix = Rails.env.test? ? '_test' : ''
    "product_photos#{affix}/#{mounted_as}/#{model_id_path}"
  end

  private


  def store_dimensions
    if file && model && model.respond_to?(:width) && model.respond_to?(:height)
      img = ::Magick::Image::read(file.file).first
      model.width = img.columns
      model.height = img.rows
    end
  end

end
