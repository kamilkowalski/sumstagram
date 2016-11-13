if defined? CarrierWave
  CarrierWave.configure do |config|
    config.asset_host = "https://" + ENV.fetch("C9_HOSTNAME", "localhost")
  end
end