CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => 'AKIAJKCHXPO77U724HFQ',    
    :aws_secret_access_key  => 'BYGyVdPNIuXwZgw1Zr+4jYx1rSZHJIoUwZ8LV+re'       
  }
  config.fog_directory  = 'ragatzi'                     
  #config.fog_host       = 'https://assets.example.com'            # optional, defaults to nil
  config.fog_public     = true                                   
  #config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
end