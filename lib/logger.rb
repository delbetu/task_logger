require 'data_structures'
require 'entry_storage'
require 'minute_dock_proxy'

class Logger
  class ValidationError < RuntimeError; end
  class ProjectNotFoundError < RuntimeError; end

  def self.create_entry(params)
    validate_params(params)
    EntryStorage.create(params)
  end

  def self.list_entries_for_today
    EntryStorage.search(date: Date.today)
  end

  def self.list_projects
    @@projects = MinuteDockProxy.list_projects
  end

  def self.select_project(project_code)
    if @@projects[project_code].present?
      @@selected_project = project_code
    else
      raise ProjectNotFoundError.new("#{project_code} is not a valid project code")
    end
  end

  private

  def self.validate_params(params)
    raise ValidationError.new('Date is required') unless params[:date].present?
  end
end
