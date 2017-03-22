# Setup here
repo   = `git ls-remote --get-url`.split(':')[1].gsub(/\.git$/, '').gsub(/[\\\n]/, '')
branch = `git rev-parse --symbolic-full-name --abbrev-ref HEAD`.gsub(/[\\\n]/, '')
cmd    = "runurl https://raw.githubusercontent.com/notebase/devops/master/bin/deploy"
common = "#{cmd} #{repo} #{branch}"

# role :web_servers, "oleherland.no"
# role :web_servers, "web1.notebase.io", "web2.notebase.io"
role :app_servers, "h1.notebase.io"

set :user, "app"

desc "Deploy Notebase repo to production"
task :deploy, :roles => :app_servers do
  run "#{common} prod update quiet"
end

desc "Deploy Notebase repo to staging"
task :stage, :roles => :app_servers do
  run "#{common} staging update quiet"
end

desc "Deploy Notebase repo to development"
task :dev, :roles => :app_servers do
  run "#{common} dev update quiet"
end
