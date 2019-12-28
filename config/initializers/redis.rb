uri = URI.parse("redis://localhost:6379")
if ENV['REDISCLOUD_URL']
    uri = URI.parse(ENV['REDISCLOUD_URL'])
end
$redis = Redis.new(host: uri.host, port: uri.port, password: uri.password)