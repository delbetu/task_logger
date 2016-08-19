require 'data_structures'
require 'entry_storage'
require 'minute_dock_proxy'

class Logger
  class ValidationError < RuntimeError; end

  def self.create_entry(params)
    validate_params(params)
    EntryStorage.create(params)
  end

  def self.list_entries_for_today
    EntryStorage.search(date: Date.today)
  end

  def self.list_projects
    MinuteDockProxy.list_projects
  end

  private

  def self.validate_params(params)
    raise ValidationError.new('Date is required') unless params[:date].present?
  end
end
