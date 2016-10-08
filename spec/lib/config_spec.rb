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

  describe '#load_task_categories' do
    it 'returns categories from file Config::TASK_CATEGORIES_PATH' do
      stub_const('Config::TASK_CATEGORIES_PATH', 'spec/fixtures/files/config_categories.yml')

      categories = {
        1 => {
          'category_id' => 1,
          'minutedock_id' => 344,
          'category' => 'Analysis'
        },
        2 => {
          'category_id' => 2,
          'minutedock_id' => 349,
          'category' => 'Implementation'
        }
      }
      expect(Config.load_task_categories).to eq(categories)
    end
  end

  describe '#store_projects' do
    it 'store projects into file' do
      system('rm -f spec/tmp/projects.yml')
      stub_const('Config::PROJECTS_PATH', 'spec/tmp/projects.yml')
      projects_hash = {
        1 => {
          'minutedock_id' => 111,
          'project' => 'First project'
        },
        2 => {
          'minutedock_id' => 222,
          'project' => 'Second project'
        }
      }

      Config.store_projects(projects_hash)

      expect(Config.load_projects).to eq(projects_hash)
    end
  end

  describe '#store_categories' do
    it 'store categories into file' do
      system('rm -f spec/tmp/projects.yml')
      stub_const('Config::TASK_CATEGORIES_PATH', 'spec/tmp/categories.yml')
      categories_hash = {
        1 => {
          'minutedock_id' => 111,
          'category' => 'Analysis'
        },
        2 => {
          'minutedock_id' => 222,
          'category' => 'Implementation'
        }
      }

      Config.store_categories(categories_hash)

      expect(Config.load_task_categories).to eq(categories_hash)
    end
  end
end
