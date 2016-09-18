require 'httparty'

# Every communication with minute dock should be wrapped up in this class
class MinuteDockProxy
  class CommunicationError < RuntimeError; end
  include HTTParty
  base_uri 'https://minutedock.com/api/v1/'

  def self.list_categories
    api_key = ENV.fetch('MINUTE_DOCK_API_KEY')
    response = get('/tasks.json', query: { api_key: api_key })
    JSON.parse(response.body).map do |taks_category|
      { taks_category['id'] => taks_category['name'] }
    end.inject(:merge)
  end

  def self.report_entry(entry)
    api_key = ENV.fetch('MINUTE_DOCK_API_KEY')
    user_id = ENV.fetch('MINUTE_DOCK_USER_ID')

    response = post("/entries.json?api_key=#{api_key}", {
      body: {
        user_id: user_id,
        entry: {
          duration: entry.duration,
          description: entry.description
        }
      }
    })
    raise CommunicationError.new if minutedock_fails?(response)
  end

  #TODO: this hide the reason of the fail
  def self.minutedock_fails?(response)
    response.headers['status'] != '200'
  end
end
