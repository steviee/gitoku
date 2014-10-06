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
BASE_DIR = File.expand_path(config['base_dir'])
puts "BASE_DIR = #{BASE_DIR}"

REPO_DIR = "#{BASE_DIR}/#{PROJECT_NAME}.git"
puts "REPO_DIR = #{REPO_DIR}"

WORK_DIR = "#{BASE_DIR}/#{PROJECT_NAME}.deploy"
puts "WORK_DIR = #{WORK_DIR}"

# try to figure out if server needs restarting
do_restart = false

# 1. Read STDIN (Format: "from_commit to_commit branch_name")
from, to, branch = ARGF.read.split " "

puts "====================================="
puts "#{PROJECT_NAME} is deploying! Say hi!"
puts "====================================="

# 2. Only deploy if master branch was pushed
#if (branch =~ /master$/) == nil
#  puts "Received branch #{branch}, not deploying."
#  exit
#end

# 3. Copy files to deploy directory
if Dir.exists?(WORK_DIR) && File.directory?(WORK_DIR)
  puts "Updating working directory."
  Dir.chdir "#{WORK_DIR}"
  system 'git checkout -f master'
  puts "DEPLOY: #{branch}(#{to}) updated in '#{WORK_DIR}'"
  do_restart = true
else
  puts "Cloning into new working directory #{WORK_DIR}."
  system 'git clone #{REPO_DIR} #{WORK_DIR}'
  puts "DEPLOY: #{branch}(#{to}) copied to '#{WORK_DIR}'"
end

# 4. Read Gitokufile
gitoku = YAML.load_file("#{WORK_DIR}/Gitokufile")

# =============================================================================================
# Stop the server
# =============================================================================================

if gitoku['server'] == "WEBrick" && do_restart
	puts "Shutting down WEBrick."
	system "kill -INT $(cat #{WORK_DIR}/tmp/pids/server.pid)"
end

if gitoku['server'] == "PhusionPassenger" && do_restart
  puts "Stopping PhusionPassenger on port #{gitoku['port']}"
  Dir.chdir "#{WORK_DIR}"
  system "./stop-staging.sh"
end

# =============================================================================================
# Run the tasks
# =============================================================================================


if gitoku['run_bundler'] == true
	puts "Running: bundle install" 
	Dir.chdir "#{WORK_DIR}"
	system 'bundle install'
end

if gitoku['run_migrations'] == true
	puts "Running: rake db:migrate" 
	Dir.chdir "#{WORK_DIR}"
	system 'rake db:migrate'
end

if gitoku['clean_assets'] == true 
	puts "Running: rake assets:clean"
	Dir.chdir "#{WORK_DIR}"
	system 'rake assets:clean'
end

if gitoku['precompile_assets'] == true 
	puts "Running: rake assets:precompile"
	Dir.chdir "#{WORK_DIR}"
	system 'rake assets:precompile'
end

# =============================================================================================
# (Re)start the server
# =============================================================================================

if gitoku['server'] == "WEBrick"
	puts "Starting WEBrick on port #{gitoku['port']}"
	Dir.chdir "#{WORK_DIR}"
  system "RAILS_ENV=#{gitoku['environment']} rails s -b #{gitoku['interface']} -p #{gitoku['port']} -d"
end

if gitoku['server'] == "PhusionPassenger"
  puts "Starting PhusionPassenger on port #{gitoku['port']}"
  Dir.chdir "#{WORK_DIR}"
  system "./start-staging.sh"
end

puts "DONE. Have a nice day!"