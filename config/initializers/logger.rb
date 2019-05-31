class BackgroundLogger < Logger
  def format_message(severity, timestamp, progname, msg)
    "#{msg}\n"
  end
end

logfile = File.open(File.join(Rails.root, "/log/bg_#{Rails.env}.log"), 'a')
logfile.sync = true
BG_LOGGER = BackgroundLogger.new(logfile, 30, 10024000)
BG_LOGGER.level = Rails.env.test? ? Logger::DEBUG : Logger::INFO
