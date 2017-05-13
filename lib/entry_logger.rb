class EntryLogger
  def self.create_entry(params)
    EntryValidator.new(params).validate
    Storage::Entry.create(params)
  end

  def self.remove_entry(entry_id)
    Storage::Entry.remove(entry_id)
  end

  def self.list_entries_for_today
    Storage::Entry.search(date: Date.today)
  end

  def self.list_projects
    Config.load_projects
  end

  def self.list_categories
    Config.load_task_categories
  end

  def self.report_pending_to_minutedock
    pending_entries = Storage::Entry.list_pending(:minutedock)
    pending_entries.each do |entry|
      MinuteDock::Proxy.report_entry(entry)
      Storage::Entry.update(entry, minutedock_reported: true)
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

  def self.setup_minutedock(api_key)
    unless MinuteDock::Proxy.valid_credentials?(api_key)
      raise MinuteDock::InvalidCredentialsError
    end
    user_id = MinuteDock::Proxy.fetch_user_id(api_key)
    MinuteDock::Config
      .store_credentials('api_key' => api_key, 'user_id' => user_id)
  end

  def self.minutedock_configured?
    MinuteDock::Proxy.valid_credentials?
  rescue MinuteDock::NoCredentialsError
    return false
  end

  def self.import_categories_from_minutedock
    categories = MinuteDock::Proxy.fetch_categories
    transform = lambda do |values, number|
      {
        number + 1 => {
          'id' => number + 1,
          'minutedock_id' => values[0],
          'category' => values[1]
        }
      }
    end

    translated_categories =
      categories.map.with_index.map(&transform).inject(&:merge)

    Config.store_categories(translated_categories)
  end
end
