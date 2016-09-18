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

  describe '#list_categories' do
    it 'fetch, returns and store categories from minutedock api' do
      fake_minutedock_proxy =
        class_double(
          'MinuteDockProxy',
          list_categories: { '222' => 'Analysis' }
      ).as_stubbed_const

      result = EntryLogger.list_categories
      expect(result['222']).to eq('Analysis')
      expect(EntryLogger.class_variable_get(:@@categories)).to eq({ '222' => 'Analysis' })
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
        minutedock_proxy_mock = class_double('MinuteDockProxy').as_stubbed_const
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
end
