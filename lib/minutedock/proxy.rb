require 'httparty'
require_relative 'config'

module MinuteDock
  # Responsible for interacting with minutedock.
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
      response = post("/entries.json?api_key=#{api_key}", body: {
                        user_id: user_id,
                        entry: {
                          duration: entry.duration,
                          description: entry.description,
                          task_ids: [entry.category_id],
                          project_id: entry.project_id
                        }
                      })

      error_message = 'Minutedock error trying to report an entry'
      raise CommunicationError, error_message if minutedock_fails?(response)
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

    # TODO: this hide the reason of the fail
    def self.minutedock_fails?(response)
      response.headers['status'] != '200'
    end

    def self.valid_credentials?(param_api_key = nil)
      response = get("/accounts.json?api_key=#{param_api_key || api_key}")
      !minutedock_fails?(response)
    end

    def self.fetch_user_id(param_api_key)
      response = get("/entries/current.json?api_key=#{param_api_key}")
      response.parsed_response['user_id']
    end
  end
end
