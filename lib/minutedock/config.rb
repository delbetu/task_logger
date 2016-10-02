module MinuteDock
  class Config
    MINUTEDOCK_CREDENTIALS = 'config/minutedock_credentials.yml'
    def self.load_minutedock_credentials
      YAML.load_file(MINUTEDOCK_CREDENTIALS)
    end
  end
end


