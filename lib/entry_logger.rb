class EntryLogger
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

  def self.list_categories
    @@categories = MinuteDockProxy.list_categories
  end

  def self.select_project(project_code)
    if @@projects[project_code].present?
      @@selected_project = project_code
    else
      raise ProjectNotFoundError.new("#{project_code} is not a valid project code")
    end
  end

  def self.report_pending_to_minutedock
    pending_entries = EntryStorage.list_pending(:minutedock)
    pending_entries.each do |entry|
      MinuteDockProxy.report_entry(entry)
      EntryStorage.update(entry, minutedock_reported: true)
    end
  end

  private

  def self.validate_params(params)
    raise ValidationError.new('Date is required') unless params[:date].present?
  end
end
