# frozen_string_literal: true

require 'active_encryption/configuration/store'

module ActiveEncryption
  # The ActiveEncryption::Configuration module contains classes and methods
  # to configure the gem.
  #
  # Usage:
  #  ActiveEncryption.configure |config|
  #    config.option_1 = true
  #    config.option_2 = false
  #  end
  #
  module Configuration
    def self.included(klass)
      klass.extend ClassMethods
    end

    # ClassMethods contains the class methods to extend when the module
    # is included in ActiveEncryption.
    module ClassMethods
      def config
        @config ||= Store.new
      end

      def configure
        yield config
      end
    end
  end
end
