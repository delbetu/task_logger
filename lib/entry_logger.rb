class EntryLogger
  def self.create_entry(params)
    EntryValidator.new(params).validate
    EntryStorage.create(params)
  end

  def self.list_entries_for_today
    EntryStorage.search(date: Date.today)
  end

  def self.list_categories
    @@categories = MinuteDockProxy.list_categories
  end

  def self.report_pending_to_minutedock
    pending_entries = EntryStorage.list_pending(:minutedock)
    pending_entries.each do |entry|
      MinuteDockProxy.report_entry(entry)
      EntryStorage.update(entry, minutedock_reported: true)
    end
  end

end
