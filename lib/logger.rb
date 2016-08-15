require 'data_structures'
require 'entry_storage'

class Logger
  class ValidationError < RuntimeError; end

  def self.create_entry(params)
    validate_params(params)
    EntryStorage.create(params)
  end

  def self.validate_params(params)
    raise ValidationError.new('Date is required') unless params[:date].present?
  end
end
