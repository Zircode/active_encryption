# frozen_string_literal: true

require 'active_encryption/encryption_setting/yaml_store'

module ActiveEncryption
  module Configuration
    # The ActiveEncryption::Configuration::Store class stores the gem
    # configuration.
    class Store
      DEFAULTS = {
        encryption_setting_store: nil,
        default_encryption_setting_id: :default
      }.freeze

      attr_accessor(*DEFAULTS.keys)

      def initialize
        reset
      end

      def reset
        DEFAULTS.each do |key, value|
          public_send("#{key}=", value)
        end
      end
    end
  end
end
