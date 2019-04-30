unless defined?(REDIS_CONFIG)
  REDIS_CONFIG = {
      host: ENV['REDIS_SERVER'] || 'localhost',
      port: 6379,
      db: 0,
      password: ENV['REDIS_PASSWORD'] || 'obv10sInj',
      namespace: "#{Rails.env}_cache"
  }
end