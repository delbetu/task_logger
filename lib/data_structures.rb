class Entry < Struct.new(:id, :date, :start_time, :end_time,
                   :project, :category, :description)

  def initialize(hash_values)
    self.id = hash_values[:id]
    self.date = hash_values[:date]
    self.start_time = hash_values[:start_time]
    self.end_time = hash_values[:end_time]
    self.project = hash_values[:project]
    self.category = hash_values[:category]
    self.description = hash_values[:description]
  end
end
