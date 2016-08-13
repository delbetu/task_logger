require 'logger'
Entry = Struct.new(:id, :date, :startime, :endtime,
                   :project, :category, :description)

describe Logger, '#log' do
  it 'returns new log entry with its id and passed attributes' do
    params = {
      date: Date.today,
      startime: Time.now,
      endtime: Time.now + 3.hours,
      project: 'Task logger',
      category: 'Analysis',
      description: 'Work on domain model'
    }
    result = Logger.create_entry(params)
    expect(result.id).not_to be_nil
    params.keys.each do |key|
      expect(result.send(key)).to eq(params[key])
    end
  end

  context 'when no required params are given' do
    it 'raises an error' do
      expect {
        Logger.create_entry({})
      }.to raise_error(Logger::ValidationError)
    end
  end
end
