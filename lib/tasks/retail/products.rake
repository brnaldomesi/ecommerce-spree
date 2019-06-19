namespace :products do

  desc 'Export Retail::ProductSpec name values to file doc/spec_names.txt, which can be used for properties or options'
  task :export_product_spec_names => :environment do
    File.open( File.join(Rails.root, 'doc/spec_names.txt'), "w:#{Encoding::ASCII_8BIT}" ) do|f|
      ::Retail::ProductSpec.where(locale: 'en-US').select(:name).distinct.each do|spec|
        next if spec.name =~ /^\d+$/
        f.write spec.name + "\n"
      end
    end
  end

end