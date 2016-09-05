require 'yaml/store'

class EntryStorage
  class EntryNotFoundError < RuntimeError; end

  def self.create(params)
    entry = Entry.new(params)
    entry.id = next_id
    file_store.save(entry)
    entry
  end

  def self.count
    all.length
  end

  def self.all
    file_store.load_entries
  end

  def self.find(id)
    all_entries = file_store.load_entries
    raise EntryNotFoundError unless all_entries[id]
    all_entries[id]
  end

  def self.search(condition)
    attribute = condition.keys[0]
    value = condition[attribute]
    entries = file_store.load_entries.values
    entries.select { |entry| entry.send(attribute) == value }
  end

  def self.list_pending(external_service)
    raise 'error' unless SERVICES_TO_REPORT.include?(external_service)

    search("#{external_service}_reported" => false)
  end

  def self.update(entry, new_values_hash)
    existing_entry = find(entry.id)
    new_values_hash.each do |attribute, value|
      existing_entry.send("#{attribute}=", value)
    end
    file_store.save(existing_entry)
  end

  private

  def self.file_store
    @@entries ||= EntryFileStore.new
  end

  def self.next_id
    max_id = file_store.load_entries.values.map(&:id).max
    if max_id.nil?
      1
    else
      max_id + 1
    end
  end
end

class EntryFileStore < YAML::Store
  FILE_PATH = 'db/entries.pstore'

  def initialize
    super(FILE_PATH)
  end

  def load_entries
    entries = {}
    transaction do
      roots.each do |key|
        entries.merge!( { key => fetch(key) } )
      end
    end
    entries
  end

  def save(entry)
    transaction do
      self[entry.id] = entry
    end
  end
end
