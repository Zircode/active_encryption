# frozen_string_literal: true

require 'active_encryption/encryption_setting/key'

module ActiveEncryption
  module EncryptionSetting
    # The ActiveEncryption::EncryptionSetting::Record contains the required
    # settings for encrypting and decrypting content.
    class Record
      ATTRIBUTES = %i[cipher digest id key purpose secret
                      secret_iterations secret_salt serializer].freeze

      attr_reader(*ATTRIBUTES)

      def self.to_h(record)
        if record.is_a?(Hash)
          record.slice(*ATTRIBUTES)
        else
          ATTRIBUTES.each_with_object({}) do |name, attributes|
            attributes[name] = record.public_send(name)
          end
        end
      end

      def self.merge(base_record, higher_priority_record)
        new(
          to_h(base_record)
            .merge(key: nil) # reset the computed key
            .merge(
              to_h(higher_priority_record)
            )
        )
      end

      def initialize(attributes)
        ATTRIBUTES.each do |name|
          instance_variable_set("@#{name}", attributes[name])
        end

        @serializer = Object.const_get(@serializer) if @serializer.is_a?(String)
      end

      def key
        @key ||= Key.new(
          secret,
          cipher: cipher,
          salt: secret_salt,
          iterations: secret_iterations
        ).value
      end

      def to_h
        self.class.to_h(self)
      end
    end
  end
end
