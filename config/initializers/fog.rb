CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',       # required
    :aws_access_key_id      => 'AKIAJKCHXPO77U724HFQ',       # required
    :aws_secret_access_key  => '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'       # required
  }
  config.fog_directory  = 'ragatzi'                     # required
  #config.fog_host       = 'https://assets.example.com'            # optional, defaults to nil
  config.fog_public     = false                                   # optional, defaults to true
  #config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
end