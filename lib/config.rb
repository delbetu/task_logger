class Config
  PROJECTS_PATH = 'config/projects.yml'
  TASK_CATEGORIES_PATH = 'config/task_categories.yml'

  def self.load_projects
    YAML.load_file(PROJECTS_PATH)['projects']
  end

  def self.load_task_categories
    YAML.load_file(TASK_CATEGORIES_PATH)['categories']
  end

  def self.store_projects(projects_hash)
    projects_hash = { 'projects' => projects_hash }
    File.open(PROJECTS_PATH, 'w') do |file|
      file.write projects_hash.to_yaml
    end
  end

end