class EntryValidator
  class ValidationError < RuntimeError; end

  def initialize(params)
    @entry = Entry.new(params)
  end

  def validate
    #TODO validate that project id is correct
    #TODO validate that category id is correct
    raise ValidationError.new('Date is required') unless @entry.date.present?
  end
end

