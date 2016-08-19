require 'httparty'

# Every communication with minute dock should be wrapped up in this class
class MinuteDockProxy
  include HTTParty
  base_uri 'https://minutedock.com/api/v1/'

  def self.list_projects
    api_key = ENV.fetch('MINUTE_DOCK_API_KEY')
    response = get('/projects.json', query: { api_key: api_key })
    JSON.parse(response.body).map do |project|
      { project['id'] => project['name'] }
    end.inject(:merge)
  end
end
