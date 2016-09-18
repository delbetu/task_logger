class Config
  PROJECTS_PATH = 'config/projects.yml'

  def self.load_projects
    YAML.load_file(PROJECTS_PATH)['projects']
  end
end
