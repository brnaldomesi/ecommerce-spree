class SystemSetting
  @@settings_loaded = nil

  def self.settings
    unless @@settings_loaded
      file_path = File.join(Rails.root, 'shared/config/system_settings.yml')
      if File.exists?(file_path)
        @@settings_loaded = YAML::load_file file_path
      end
    end
    @@settings_loaded ||= {}
    @@settings_loaded
  end
end