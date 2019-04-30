Sidekiq.configure_server do |config|
  config.redis = REDIS_CONFIG

end

Sidekiq.configure_client do |config|
  config.redis = REDIS_CONFIG
end

Sidekiq.default_worker_options = { throttle: { threshold: 4, period: 1.second } }
