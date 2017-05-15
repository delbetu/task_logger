require 'yaml/store'

module Storage
  class EntryFileStore < YAML::Store
    FILE_PATH = 'db/entries.pstore'.freeze

    def initialize
      super(FILE_PATH)
    end

    def load_entries
      entries = {}
      transaction do
        roots.each do |key|
          entries.merge!(key => fetch(key))
        end
      end
      entries
    end

    def remove_file!
      system("rm -f #{FILE_PATH}")
    end

    def save(entry)
      transaction do
        self[entry.id] = entry
      end
    end
  end
end
