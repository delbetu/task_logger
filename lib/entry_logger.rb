class EntryLogger
  def self.create_entry(params)
    EntryValidator.new(params).validate
    EntryStorage.create(params)
  end

  def self.list_entries_for_today
    EntryStorage.search(date: Date.today)
  end

  def self.list_projects
    Config.load_projects
  end

  def self.list_categories
    Config.load_task_categories
  end

  def self.report_pending_to_minutedock
    pending_entries = EntryStorage.list_pending(:minutedock)
    pending_entries.each do |entry|
      MinuteDock::Proxy.report_entry(entry)
      EntryStorage.update(entry, minutedock_reported: true)
    end
  end

  def self.import_projects_from_minutedock
    projects = MinuteDock::Proxy.fetch_projects

    translated_projects = projects.map.with_index do |r, index|
      {
        index + 1 => {
          'id' => index + 1,
          'minutedock_id' => r[0],
          'project' => r[1]
        }
      }
    end.inject(&:merge)

    Config.store_projects(translated_projects)
  end
end
