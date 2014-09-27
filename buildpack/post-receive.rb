#!/usr/bin/env ruby
# post-receive
require "yaml"

THIS_FILE = File.symlink?(__FILE__) ? File.readlink(__FILE__) : __FILE__
THIS_DIR = File.expand_path(File.dirname(THIS_FILE))

puts "THIS_DIR = #{THIS_DIR}"
config = YAML.load_file("#{THIS_DIR}/config.yml")

require "#{THIS_DIR}/helper"

# This will become the Gitokufile
PROJECT_NAME = get_project_name(__FILE__)
SERVER = "webbrick"

# EOF (Gitokufile)
BASE_DIR = config['base_dir']

puts "BASE_DIR = #{BASE_DIR}"
REPO_DIR = "#{BASE_DIR}#{PROJECT_NAME}.git"
WORK_DIR = "#{BASE_DIR}#{PROJECT_NAME}.deploy"


# try to figure out if server needs restarting
RESTART = false

# 1. Read STDIN (Format: "from_commit to_commit branch_name")
from, to, branch = ARGF.read.split " "

puts "====================================="
puts "#{PROJECT_NAME} is deploying! Say hi!"
puts "====================================="

# 2. Only deploy if master branch was pushed
if (branch =~ /master$/) == nil
  puts "Received branch #{branch}, not deploying."
  exit
end

# 3. Copy files to deploy directory
if File.exists?(WORK_DIR) && File.directory?(WORK_DIR)
  puts "Updating working directory."
  `GIT_WORK_TREE="#{WORK_DIR}" git checkout -f master`
  puts "DEPLOY: master(#{to}) updated in '#{WORK_DIR}'"
  RESTART = true
else
  puts "Cloning into new working directory."
  `git clone #{REPO_DIR} #{WORK_DIR}`
  puts "DEPLOY: master(#{to}) copied to '#{WORK_DIR}'"
end

# 4. Read Gitokufile
gitoku = YAML.load_file("#{WORK_DIR}/Gitokufile")

# Stop the server
if gitoku['server'] == "WEBrick" && RESTART
	`kill -INT $(#{WORK_DIR}/tmp/pids/server.pid)`
end

if gitoku['run_bundler'] == true 
	chdir "#{WORK_DIR}"
	`bundle install`
end

if gitoku['run_migrations'] == true 
	chdir "#{WORK_DIR}"
	`rake db:migrate`
end

if gitoku['clean_assets'] == true 
	chdir "#{WORK_DIR}"
	`rake assets:clean`
end

if gitoku['precompile_assets'] == true 
	chdir "#{WORK_DIR}"
	`rake assets:precompile`
end

# (re)start the server
if gitoku['server'] == "WEBrick"
	chdir "#{WORK_DIR}"
	`rails s -p #{gitoku['port']} -d`
end

puts "DONE. Have a nice day!"