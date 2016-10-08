require 'spec_helper'

describe Storage::Entry do
  before(:each) do
    system('rm -f spec/db/entries.pstore')
    stub_const('Storage::EntryFileStore::FILE_PATH', 'spec/db/entries.pstore')
  end

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

  describe '#create' do
    it 'creates and stores new Entry and returns the new id' do
      result = Storage::Entry.create(valid_params)

      expect(result.id).not_to be_nil
    end
  end

  describe '#search' do
    it 'returns entries which have given value and attribute' do
      returned = Storage::Entry.create(valid_params)
      entry_for_tomorrow = valid_params.merge(date: Date.today + 1.day)
      Storage::Entry.create(entry_for_tomorrow)

      result = Storage::Entry.search(date: Date.today)

      expect(result.count).to eq(1)
      expect(result).to include(returned)
    end
  end

  describe '#list_pending' do
    it 'returns the entries which were not sent to the service in question' do
      reported = Storage::Entry.create(valid_params.dup.merge(minutedock_reported: true))
      non_reported = Storage::Entry.create(valid_params)

      result = Storage::Entry.list_pending(:minutedock)

      expect(result).to include(non_reported)
      expect(result).not_to include(reported)
    end
    it 'check params is included in existing services' do
      expect do
        Storage::Entry.list_pending(:non_existing_service)
      end.to raise_error(RuntimeError)
    end
  end

  describe '#update' do
    it 'update the values given by param' do
      existing_entry = Storage::Entry.create(valid_params)
      tomorrow = Date.tomorrow

      Storage::Entry.update(existing_entry, date: tomorrow)

      expect(Storage::Entry.find(existing_entry.id).date).to eq(tomorrow)
    end
  end

  describe '#find' do
    it 'raises EntryNotFoundError when ecntry not exists yet' do
      expect do
        Storage::Entry.find(111)
      end.to raise_error(Storage::EntryNotFoundError)
    end
  end
end
