require 'httparty'

# Every communication with minute dock should be wrapped up in this class
class MinuteDockProxy
  def self.api_url
    'https://minutedock.com/api/v1'
  end

  def self.list_projects
    api_key = ENV.fetch('MINUTE_DOCK_API_KEY')
    response = HTTParty.get("#{api_url}/projects.json?api_key=#{api_key}")
    JSON.parse(response.body).map do |project|
      { project['id'] => project['name'] }
    end.inject(:merge)
  end
end
