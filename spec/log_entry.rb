require 'logger'

def create_entry_storage_mock
  class_double(
    'EntryStorage', {
      create: nil
    }).as_stubbed_const()
end

describe Logger, '#create_entry' do
  let!(:entry_storage_mock) { create_entry_storage_mock }
  let(:valid_params) do
    {
      date: Date.today,
      startime: Time.now,
      endtime: Time.now + 3.hours,
      project: 'Task logger',
      category: 'Analysis',
      description: 'Work on domain model'
    }
  end

  it 'returns new log entry with its id and passed attributes' do
    result = Logger.create_entry(valid_params)
    expect(result.id).not_to be_nil
    valid_params.keys.each do |key|
      expect(result.send(key)).to eq(valid_params[key])
    end
  end

  it 'stores info in entry storage' do
    Logger.create_entry(valid_params)
    expect(entry_storage_mock).to have_received(:create).with(valid_params)
  end

  context 'when no required params are given' do
    it 'raises an error' do
      expect {
        Logger.create_entry({})
      }.to raise_error(Logger::ValidationError)
    end
  end
end
