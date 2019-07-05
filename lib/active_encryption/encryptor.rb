# frozen_string_literal: true

require 'active_support/message_encryptor'

module ActiveEncryption
  # The ActiveEncryption::Encryptor is an abstraction class around
  # ActiveSupport::MessageEncryptor
  #
  # Usage:
  #
  # encryptor = ActiveEncryption::Encryptor.new(encryption_setting)
  # encrypted_data = encryptor.encrypt(data)
  # data = encryptor.decrypt(encrypted_data)
  #
  class Encryptor
    attr_reader :encryption_setting

    def initialize(encryption_setting, service = nil)
      @encryption_setting = encryption_setting
      @service = service
    end

    # :reek:LongParameterList is required to map to encrypt_and_sign
    def encrypt(data, expires_at: nil, expires_in: nil, purpose: nil)
      return nil unless data

      service.encrypt_and_sign(
        data,
        expires_at: expires_at,
        expires_in: expires_in,
        purpose: purpose
      )
    end

    def decrypt(data, purpose: nil)
      return nil unless data

      service.decrypt_and_verify(
        data,
        purpose: purpose
      )
    end

    private

    def service
      @service ||= ActiveSupport::MessageEncryptor.new(
        encryption_setting.key,
        cipher: encryption_setting.cipher,
        digest: encryption_setting.digest,
        serializer: encryption_setting.serializer
      )
    end
  end
end
