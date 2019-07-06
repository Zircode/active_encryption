# frozen_string_literal: true

require 'active_encryption/version'
require 'active_encryption/configuration'
require 'active_encryption/encryptable'

# The top-level ActiveEncryption module isolates the gem from the host
# application.
module ActiveEncryption
  include Configuration
  # The ActiveEncryption::Error is the base class for ActiveEncryption errors.
  class Error < StandardError; end
end
