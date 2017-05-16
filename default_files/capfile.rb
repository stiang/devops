# Setup here
repo   = `git ls-remote --get-url`.split(':')[1].gsub(/\.git$/, '').gsub(/[\\\n]/, '')
branch = `git rev-parse --symbolic-full-name --abbrev-ref HEAD`.gsub(/[\\\n]/, '')
cmd    = "runurl https://raw.githubusercontent.com/stiang/devops/master/bin/deploy"
common = "#{cmd} #{repo} #{branch}"

role :app_servers, "cryptotrader.grytoyr.net"

set :user, "app"

desc "Deploy CryptoTrader repo to production"
task :deploy, :roles => :app_servers do
  run "#{common} prod update quiet"
end

desc "Deploy CryptoTrader repo to staging"
task :stage, :roles => :app_servers do
  run "#{common} staging update quiet"
end

desc "Deploy CryptoTrader repo to development"
task :dev, :roles => :app_servers do
  run "#{common} dev update quiet"
end
