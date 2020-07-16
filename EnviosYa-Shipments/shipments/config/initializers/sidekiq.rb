Sidekiq.configure_server do |config|
  config.redis = { url: JSON.parse(ENV["VCAP_SERVICES"] || "{}")
                             &.fetch("compose-for-redis", nil)
                             &.first
                             &.dig("credentials", "uri") }
  schedule_file = "config/schedule.yml"
  if File.exists?(schedule_file)
    Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: JSON.parse(ENV["VCAP_SERVICES"] || "{}")
                             &.fetch("compose-for-redis", nil)
                             &.first
                             &.dig("credentials", "uri")}
end