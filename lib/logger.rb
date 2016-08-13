class Logger
  class ValidationError < RuntimeError; end

  def self.create_entry(params)
    validate_params(params)
    Entry.new(1, params[:date], params[:startime], params[:endtime],
              params[:project], params[:category], params[:description])
  end

  def self.validate_params(params)
    raise ValidationError.new('Date is required') unless params[:date].present?
  end
end
