#!/usr/bin/env ruby
# post-receive


# This will become the Gitokufile
PROJECT_NAME = "gauntlet"
BASE_DIR = "/var/git/"
REPO_DIR = "#{BASE_DIR}#{PROJECT_NAME}.git"
WORK_DIR = "#{BASE_DIR}#{PROJECT_NAME}.deploy"

# EOF
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
if Dir.exist?(WORK_DIR)
  `GIT_WORK_TREE="#{WORK_DIR}" git checkout -f master`
  puts "DEPLOY: master(#{to}) updated in '#{WORK_DIR}'"
  RESTART = true
else
  `GIT_WORK_TREE="#{WORK_DIR}" git clone #{REPO_DIR} #{WORK_DIR}`
  puts "DEPLOY: master(#{to}) copied to '#{WORK_DIR}'"
end

