#!/usr/bin/env ruby
require "yaml"

THIS_FILE = File.symlink?(__FILE__) ? File.readlink(__FILE__) : __FILE__
THIS_DIR = File.expand_path(File.dirname(THIS_FILE))

config = YAML.load_file("#{THIS_DIR}/config.yml")

require "#{THIS_DIR}/helper"

PROJECT_NAME = ARGV[0]
HOSTNAME = get_host_name
BASE_DIR = config['base_dir']
SCRIPT_DIR = THIS_DIR

puts "Trying to create project #{PROJECT_NAME} on #{HOSTNAME}"

if File.directory?("#{BASE_DIR}#{PROJECT_NAME}.git") 
  puts "Project already exists."
  exit!
end

`git init --bare #{BASE_DIR}#{PROJECT_NAME}.git`
`ln -s #{SCRIPT_DIR}/post-receive.rb #{BASE_DIR}#{PROJECT_NAME}.git/hooks/post-receive`
`chmod +x #{BASE_DIR}#{PROJECT_NAME}.git/hooks/post-receive`

puts "Project created."
puts ""
puts "Use git remote add gitoku git@#{HOSTNAME}:#{BASE_DIR}#{PROJECT_NAME}.git"
