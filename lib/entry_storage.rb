require 'data_structures'

class EntryStorage
  def self.create(params)
    @@entries ||= []
    entry = Entry.new(params)
    entry.id = next_id
    @@entries << entry
    entry
  end

  def self.search(condition)
    attribute = condition.keys[0]
    value = condition[attribute]
    @@entries.select { |entry| entry.send(attribute) == value }
  end

  #TODO: This is only for testing purpose. Search another solution for this
  def self.clean_storage
    @@entries = []
  end

  private

  def self.next_id
    @@count ||= 0
    @@count += 1
  end
end
