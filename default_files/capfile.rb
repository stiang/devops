# Setup here
repo   = `git ls-remote --get-url`.split(':')[1].gsub(/\.git$/, '').gsub(/[\\\n]/, '')
branch = `git rev-parse --symbolic-full-name --abbrev-ref HEAD`.gsub(/[\\\n]/, '')
cmd    = "runurl https://raw.githubusercontent.com/notebase/devops/master/bin/deploy"
common = "#{cmd} #{repo} #{branch}"

# role :web_servers, "oleherland.no"
role :web_servers, "web1.notebase.io", "web2.notebase.io"

set :user, "notebase"

desc "Deploy Notebase Web Site to production"
task :deploy, :roles => :web_servers do
  run "#{common} prod update quiet"
end

desc "Deploy Notebase Web Site to staging"
task :stage, :roles => :web_servers do
  run "#{common} staging update quiet"
end

desc "Deploy Notebase Web Site to development"
task :dev, :roles => :web_servers do
  run "#{common} dev update quiet"
end
