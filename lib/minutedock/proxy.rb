require 'httparty'

# Every communication with minute dock should be wrapped up in this class
module MinuteDock
  class Proxy
    include HTTParty
    base_uri 'https://minutedock.com/api/v1/'

    def self.api_key
      @@api_key ||= Config.load_minutedock_credentials['api_key']
    end

    def self.user_id
      @@user_id ||= Config.load_minutedock_credentials['user_id']
    end

    def self.report_entry(entry)
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

    def self.fetch_projects
      response = get(
        '/projects.json',
        query: { active: true, api_key: api_key }
      )
      JSON.parse(response.body).map do |project|
        { project['id'] => project['name'] }
      end.inject(:merge)
    end

    def self.fetch_categories
      response = get('/tasks.json', query: { api_key: api_key })
      JSON.parse(response.body).map do |taks_category|
        { taks_category['id'] => taks_category['name'] }
      end.inject(:merge)
    end

    #TODO: this hide the reason of the fail
    def self.minutedock_fails?(response)
      response.headers['status'] != '200'
    end
  end
end
