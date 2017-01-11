CarrierWave.configure do |config|
  config.fog_credentials = {
      provider:              'AWS',
      aws_access_key_id:     ENV["AWS_ACCESS_KEY_ID"],
      aws_secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
      region:                'ap-northeast-1',
      path_style:            true,
  }

  config.fog_public     = true
  config.fog_attributes = {'Cache-Control' => 'public, max-age=86400'}

  config.fog_directory = ENV['AWS_S3_BUCKET']
  config.asset_host = ENV['AWS_S3_URL']
=begin
  case Rails.env
    when 'production'
      config.fog_directory = 'facemask-heroku'
      config.asset_host = 'https://s3-ap-northeast-1.amazonaws.com/facemask-heroku'
    when 'development'
      config.fog_directory = 'facemask-develop'
      config.asset_host = 'https://s3-ap-northeast-1.amazonaws.com/facemask-develop'
  end
=end
end
