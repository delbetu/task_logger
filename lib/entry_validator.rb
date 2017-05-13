# Responsible for validating Entries
class EntryValidator
  class ValidationError < RuntimeError; end

  def initialize(params)
    @entry = EntryValue.new(params)
  end

  def validate
    # TODO: validate that project id is correct
    # TODO: validate that category id is correct
    validate_date
    validate_duration
  end

  private

  def validate_date
    error_message = 'Date is required'
    raise ValidationError, error_message unless @entry.date.present?
  end

  def validate_duration
    return unless @entry.duration.present?
    error_message = 'Duration must be in seconds'
    raise ValidationError, error_message unless @entry.duration.is_a?(Numeric)
  end
end
