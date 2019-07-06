# frozen_string_literal: true

require 'active_encryption/encryptable/instance_methods_on_activation'

module ActiveEncryption
  # The ActiveEncryption::Encryptable encapsulates methods and classes to
  # make a model attribute encryptable.
  #
  # Usage:
  #
  #  class MyModel
  #    extend ActiveEncryption::Encryptable
  #    encrypted_attr :my_attribute
  #  end
  #
  module Encryptable
    def encrypted_attr(attribute_name, options = {})
      include InstanceMethodsOnActivation.new(attribute_name, options)
    end

    # :reek:UtilityFunction should be ok for ClassMethod modules?
    def encryption_setting
      config = ActiveEncryption.config
      store  = config.encryption_setting_store
      id     = config.default_encryption_setting_id
      store.find(id)
    end
  end
end
