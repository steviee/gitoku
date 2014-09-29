
# identify project name
def get_project_name(file)
  script_path = File.dirname(File.expand_path(file))
  from = script_path.scan(/\w+\.git/)
  return File.basename(from[0], '.git')
end

def get_host_name
  return `hostname`
end