class Entry < Struct.new(:id, :date, :duration,
                   :project, :category, :description)

  def initialize(hash_values)
    self.id = hash_values[:id]
    self.date = hash_values[:date]
    self.duration = hash_values[:duration]
    self.project = hash_values[:project]
    self.category = hash_values[:category]
    self.description = hash_values[:description]
  end
end
