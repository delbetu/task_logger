class EntryValidator
  class ValidationError < RuntimeError; end

  def initialize(params)
    @entry = Entry.new(params)
  end

  def validate
    #TODO validate that project id is correct
    #TODO validate that category id is correct
    validate_date
    validate_duration
  end

  private

  def validate_date
    raise ValidationError.new('Date is required') unless @entry.date.present?
  end

  def validate_duration
    if @entry.duration.present?
      raise ValidationError.new('Duration must be in seconds') unless @entry.duration.is_a?(Numeric)
    end
  end
end

