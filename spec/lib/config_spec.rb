require 'spec_helper'

describe Config do
  describe '#load_projects' do
    it 'returns projects from file Config::PROJECTS_PATH' do
      stub_const('Config::PROJECTS_PATH', 'spec/fixtures/files/config_projects.yml')

      projects = {
        1 => {
          'project_id' => 1,
          'minutedock_id' => 345,
          'project' => 'Project name'
        },
        2 => {
          'project_id' => 2,
          'minutedock_id' => 234,
          'project' => 'Project name 2'
        }
      }
      expect(Config.load_projects).to eq(projects)
    end

    it 'raises error if file not exist'
  end
end
