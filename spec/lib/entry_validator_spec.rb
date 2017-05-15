require 'spec_helper'

describe EntryValidator do
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

  describe '#validate' do
    it 'raises error if duration is not in seconds' do
      validator = EntryValidator.new(valid_params.merge(duration: '22'))
      expect do
        validator.validate
      end.to raise_error(EntryValidator::ValidationError)
    end
  end
end
