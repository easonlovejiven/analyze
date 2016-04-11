# 增加/resque访问的认证控制
Resque::Server.use(Rack::Auth::Basic) do |user, password|
  password == "secret"
end