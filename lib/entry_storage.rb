require 'yaml/store'

class EntryStorage
  def self.create(params)
    @@entries ||= EntryFileStore.new
    entry = Entry.new(params)
    entry.id = next_id
    @@entries.save(entry)
    entry
  end

  def self.search(condition)
    @@entries ||= EntryFileStore.new
    attribute = condition.keys[0]
    value = condition[attribute]
    entries = @@entries.load_entries.values
    entries.select { |entry| entry.send(attribute) == value }
  end

  private

  def self.next_id
    max_id = @@entries.load_entries.values.map(&:id).max
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
