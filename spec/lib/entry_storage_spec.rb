require 'spec_helper'
require 'entry_storage'

describe EntryStorage do
  before(:each) do
    system('rm -f spec/db/entries.pstore')
    stub_const('EntryFileStore::FILE_PATH', 'spec/db/entries.pstore')
  end

  let(:valid_params) do
    {
      date: Date.today,
      duration: 3.hours,
      project: 'Task logger',
      category: 'Analysis',
      description: 'Work on domain model'
    }
  end

  describe '#create' do
    it 'creates and stores new Entry and returns the new id' do
      result = EntryStorage.create(valid_params)

      expect(result.id).not_to be_nil
    end
  end

  describe '#search' do
    it 'returns entries which have given value and attribute' do
      returned = EntryStorage.create(valid_params)
      entry_for_tomorrow = valid_params.merge(date: Date.today + 1.day)
      EntryStorage.create(entry_for_tomorrow)

      result = EntryStorage.search(date: Date.today)

      expect(result.count).to eq(1)
      expect(result).to include(returned)
    end
  end

  describe '#list_pending' do
    it 'returns the entries which were not sent to the service in question' do
      reported = EntryStorage.create(valid_params.dup.merge(minutedock_reported: true))
      non_reported = EntryStorage.create(valid_params)

      result = EntryStorage.list_pending(:minutedock)

      expect(result).to include(non_reported)
      expect(result).not_to include(reported)
    end
    it 'check params is included in existing services' do
      expect do
        EntryStorage.list_pending(:non_existing_service)
      end.to raise_error(RuntimeError)
    end
  end

  describe '#update' do
    it 'update the values given by param' do
      existing_entry = EntryStorage.create(valid_params)
      tomorrow = Date.tomorrow

      EntryStorage.update(existing_entry, date: tomorrow)

      expect(EntryStorage.find(existing_entry.id).date).to eq(tomorrow)
    end
  end

  describe '#find' do
    it 'raises EntryNotFoundError when ecntry not exists yet' do
      expect do
        EntryStorage.find(111)
      end.to raise_error(EntryStorage::EntryNotFoundError)
    end
  end
end
