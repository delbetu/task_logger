require 'logger'

def create_entry_storage_mock
  class_double(
    'EntryStorage', {
      create: double(id: 1)
    }).as_stubbed_const
end

describe Logger do
  describe '#create_entry' do
    let(:valid_params) do
      {
        date: Date.today,
        duration: 3.hours,
        project: 'Task logger',
        category: 'Analysis',
        description: 'Work on domain model'
      }
    end

    it 'stores info in entry storage' do
      entry_storage_mock = create_entry_storage_mock
      result = Logger.create_entry(valid_params)
      expect(entry_storage_mock).to have_received(:create).with(valid_params)
      expect(result.id).not_to be_nil
    end

    context 'when no required params are given' do
      it 'raises an error' do
        entry_storage_mock = create_entry_storage_mock
        expect {
          Logger.create_entry({})
        }.to raise_error(Logger::ValidationError)
      end
    end
  end

  describe '#list_entries_for_today' do
    it 'returns entries for today' do
      entry_storage_mock =
        class_double('EntryStorage', search: [1, 2]).as_stubbed_const
      Logger.list_entries_for_today
      expect(entry_storage_mock).to have_received(:search).
        with(date: Date.today)
    end
  end
end
