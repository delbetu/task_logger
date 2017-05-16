require 'yaml'
require_relative 'errors'

module MinuteDock
  # Responsible for loading and storing minutedock credentials
  class Config
    MINUTEDOCK_CREDENTIALS = 'config/minutedock_credentials.yml'.freeze

    def self.load_minutedock_credentials
      YAML.load_file(MINUTEDOCK_CREDENTIALS)
    rescue Errno::ENOENT
      raise NoCredentialsError
    end

    def self.store_credentials(credentials)
      File.open(MINUTEDOCK_CREDENTIALS, 'w') do |file|
        file.write credentials.to_yaml
      end
    end
  end
end
