
# identify project name
def get_project_name
  script_path = File.dirname(File.expand_path(__FILE__))
  from = script_path.scan(/\w+\.git/)
  return File.basename(from[0], '.git')
end

def get_host_name
  return "gauntlet"
end