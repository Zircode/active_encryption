# frozen_string_literal: true

require 'active_support/key_generator'
require 'active_support/message_encryptor'

module ActiveEncryption
  module EncryptionSetting
    # The ActiveEncryption::EncryptionSetting::Key class wraps around
    # ActiveSupport::KeyGenerator
    class Key
      DEFAULT_SALT = 'ActiveEncryption default key salt'

      attr_reader :salt, :iterations

      def initialize(secret, salt: nil, cipher: nil, iterations: nil)
        salt ||= DEFAULT_SALT
        @salt       = salt
        @cipher     = cipher
        @iterations = iterations
        @generator  = ActiveSupport::KeyGenerator.new(
          secret,
          iterations: iterations
        )
      end

      def value
        @generator.generate_key(salt, length)
      end

      def cipher
        @cipher ||= ActiveSupport::MessageEncryptor.default_cipher
      end

      def length
        ActiveSupport::MessageEncryptor.key_len(cipher)
      end
    end
  end
end
