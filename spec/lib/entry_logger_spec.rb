require 'entry_logger'

def create_entry_storage_mock
  class_double(
    'EntryStorage', {
      create: double(id: 1)
    }).as_stubbed_const
end

describe EntryLogger do
  describe '#create_entry' do
    let(:valid_params) do
      {
        date: Date.today,
        duration: 3.hours.seconds.to_i,
        project: 'Task logger',
        project_id: 1,
        category: 'Analysis',
        description: 'Work on domain model'
      }
    end

    it 'stores info in entry storage' do
      entry_storage_mock = create_entry_storage_mock
      result = EntryLogger.create_entry(valid_params)
      expect(entry_storage_mock).to have_received(:create).with(valid_params)
      expect(result.id).not_to be_nil
    end

    context 'when no required params are given' do
      it 'raises an error' do
        entry_storage_mock = create_entry_storage_mock
        expect {
          EntryLogger.create_entry({})
        }.to raise_error(EntryValidator::ValidationError)
      end
    end
  end

  describe '#list_entries_for_today' do
    it 'returns entries for today' do
      entry_storage_mock =
        class_double('EntryStorage', search: [1, 2]).as_stubbed_const
      EntryLogger.list_entries_for_today
      expect(entry_storage_mock).to have_received(:search).
        with(date: Date.today)
    end
  end

  describe '#list_projects' do
    it 'returns a list of projects from configuration' do
      projects = {
        1 => {
          project_id: 1,
          minutedock_id: 234,
          project: 'Project name'
        },
        2 => {
          project_id: 2,
          minutedock_id: 234,
          project: 'Project name'
        }
      }
      class_double('Config', load_projects: projects).as_stubbed_const
      result = EntryLogger.list_projects
      expect(result).to eq(projects)
    end
  end

  describe '#list_categories' do
    it 'returns a list of projects from configuration' do
      task_categories = {
        1 => {
          'category_id' => 1,
          'minutedock_id' => 234,
          'category' => 'Analysis'
        }
      }
      class_double('Config', load_task_categories: task_categories).as_stubbed_const
      result = EntryLogger.list_categories
      expect(result).to eq(task_categories)
    end
  end

  describe '#import_projects_from_minutedock' do
    it 'fetch projects from minutedock and saves them into projects config file' do
      sample_projects = { 15153 => "ConnectedHealth", 15154 => "Red Stamp Legacy" }
      minutedock = class_double('MinuteDock::Proxy', fetch_projects: sample_projects).as_stubbed_const
      config = class_double('Config', store_projects: nil).as_stubbed_const

      EntryLogger.import_projects_from_minutedock
      expect(minutedock).to have_received(:fetch_projects)
      expect(config).to have_received(:store_projects).with(
        {
          1 => { "id" => 1, "minutedock_id" => 15153, "project" => "ConnectedHealth" },
          2 => { "id" => 2, "minutedock_id" => 15154, "project" => "Red Stamp Legacy" }
        }
      )
    end
  end

  describe '#report_pending_to_minutedock' do
    context 'when there is a non reported entry' do
      let(:non_reported_entry) do
        Entry.new({
          id: 1,
          date: Date.today,
          duration: 3.hours.seconds.to_i,
          project: 'Task logger',
          project_id: 1,
          category: 'Analysis',
          description: 'Work on domain model',
          minutedock_reported: false
        })
      end
      let!(:entry_storage_mock) do
        entry_storage_mock = class_double('EntryStorage').as_stubbed_const
        allow(entry_storage_mock).to receive(:list_pending).with(:minutedock).and_return([ non_reported_entry ])
        allow(entry_storage_mock).to receive(:update).with(non_reported_entry, minutedock_reported: true)
        entry_storage_mock
      end
      let!(:minutedock_proxy_mock) do
        minutedock_proxy_mock = class_double('MinuteDock::Proxy').as_stubbed_const
        allow(minutedock_proxy_mock).to receive(:report_entry).with(non_reported_entry)
        minutedock_proxy_mock
      end

      it 'marks entry as reported and reports to minutedock' do
        EntryLogger.report_pending_to_minutedock

        expect(entry_storage_mock).to have_received(:list_pending).with(:minutedock)
        expect(entry_storage_mock).to have_received(:update).with(non_reported_entry, minutedock_reported: true)
        expect(minutedock_proxy_mock).to have_received(:report_entry).with(non_reported_entry)
      end
    end
    it 'manage exception when minutedock service fails'
  end

  describe '#setup_minutedock' do
    it 'raises an error when given credentials are invalid' do
      allow(MinuteDock::Proxy).to receive(:valid_credentials?).and_return(false)

      expect {
        EntryLogger.setup_minutedock('invalid-api-key')
      }.to raise_error MinuteDock::InvalidCredentialsError
    end

    it 'stores given credentials when credentials are valid' do
      config = class_double('MinuteDock::Config', store_credentials: nil).as_stubbed_const
      allow(MinuteDock::Proxy).to receive(:valid_credentials?).and_return(true)
      allow(MinuteDock::Proxy).to receive(:fetch_user_id).and_return(1111)
      api_key = 'valid-api-key'

      EntryLogger.setup_minutedock(api_key)

      expect(config).to have_received(:store_credentials).with(
        { 'api_key' => api_key, 'user_id' => 1111 }
      )
    end
  end
end
