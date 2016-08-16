require 'spec_helper'
require 'entry_storage'

describe EntryStorage do
  before(:each) do
    EntryStorage.clean_storage
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
end
