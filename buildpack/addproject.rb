#!/usr/bin/env ruby

PROJECT_NAME = $1
BASE_DIR = "/var/git/"

HOSTNAME = `hostname -f`

if Dir["#{BASE_DIR}${PROJECT_NAME}.git"] != nil
  puts "Project already exists."
  exit!
end

`git init --bare #{BASE_DIR}${PROJECT_NAME}.git`
`ln -s /var/git/gitoku/buildpack/post-receive.rb #{BASE_DIR}${PROJECT_NAME}.git/hooks/post-receive`

puts "Project created."
puts ""
puts "Use git remote add gitoku git@#{HOSTNAME}:#{BASE_DIR}${PROJECT_NAME}.git"
