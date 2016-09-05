SERVICES_TO_REPORT = [ :minutedock ]

#TODO: save project_id and category_id
class Entry < Struct.new(:id, :date, :duration, :project, :category,
                         :description, :minutedock_reported)

  def initialize(hash_values)
    self.id = hash_values[:id]
    self.date = hash_values[:date]
    self.duration = hash_values[:duration]
    self.project = hash_values[:project]
    self.category = hash_values[:category]
    self.description = hash_values[:description]
    self.minutedock_reported = hash_values[:minutedock_reported] || false
  end
end
