require 'data_structures'

class EntryStorage
  def self.create(params)
    @@entries ||= []
    entry = Entry.new(params)
    entry.id = next_id
    @@entries << entry
    entry
  end

  private

  def self.next_id
    @@count ||= 0
    @@count += 1
  end
end
