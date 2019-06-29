# frozen_string_literal: true

require 'erb'
require 'yaml'
require 'active_encryption/encryption_setting/record'
require 'active_support/core_ext/hash'

module ActiveEncryption
  module EncryptionSetting
    # The ActiveEncryption::EncryptionSetting::YamlStore class retrieve
    # ActiveEncryption::EncryptionSetting::Record from a YAML file.
    class YamlStore
      attr_reader :file_path

      def initialize(file_path)
        @file_path = file_path
      end

      def find(id)
        id = id.to_sym
        attributes = content[id]
        return nil unless attributes

        attributes[:id] = id
        Record.new(attributes)
      end

      def content
        @content ||= parse_file.deep_symbolize_keys
      end

      private

      def parse_file
        YAML.safe_load(ERB.new(File.read(file_path)).result)
      end
    end
  end
end
