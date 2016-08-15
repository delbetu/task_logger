require 'spec_helper'
require 'entry_storage'

describe EntryStorage, '#create' do
  it 'creates and stores new Entry and returns the new id' do
    valid_params = {
      date: Date.today,
      start_time: Time.now,
      end_time: Time.now + 3.hours,
      project: 'Task logger',
      category: 'Analysis',
      description: 'Work on domain model'
    }

    result = EntryStorage.create(valid_params)

    expect(result.id).not_to be_nil
  end
end
