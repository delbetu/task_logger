require 'active_support/core_ext/object'
require 'dotenv'
Dotenv.load
require_relative 'lib/data_structures.rb'
require_relative 'lib/minutedock/config.rb'
require_relative 'lib/minutedock/errors.rb'
require_relative 'lib/minutedock/proxy.rb'
require_relative 'lib/entry_validator.rb'
require_relative 'lib/entry_storage.rb'
require_relative 'lib/entry_logger.rb'
require_relative 'lib/config.rb'

