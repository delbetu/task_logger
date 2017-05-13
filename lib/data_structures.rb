SERVICES_TO_REPORT = [:minutedock].freeze

EntryValue =
  Struct.new(:id, :date, :duration, :project, :project_id,
             :category, :category_id, :description, :minutedock_reported) do

    def initialize(hash_values)
      self.id = hash_values[:id]
      self.date = hash_values[:date]
      self.duration = hash_values[:duration]
      self.project = hash_values[:project]
      self.project_id = hash_values[:project_id]
      self.category = hash_values[:category]
      self.category_id = hash_values[:category_id]
      self.description = hash_values[:description]
      self.minutedock_reported = hash_values[:minutedock_reported] || false
    end
  end
