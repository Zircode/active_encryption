# frozen_string_literal: true

require 'active_encryption/version'
require 'active_encryption/encryption_setting/yaml_store'

module ActiveEncryption
  # The ActiveEncryption::Error is the base class for ActiveEncryption errors.
  class Error < StandardError; end
end
