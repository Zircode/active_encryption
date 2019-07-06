# frozen_string_literal: true

require 'active_encryption/encryptor'

module ActiveEncryption
  module Encryptable
    # InstanceMethodsOnActivation adds instance methods for the attribute
    # "attribute_name" to the including class.
    class InstanceMethodsOnActivation < Module
      def initialize(attribute_name, options)
        define_generic_methods
        define_attribute_accessors(attribute_name, options)
      end

      def define_generic_methods
        define_encrypt
        define_decrypt
      end

      def define_encrypt
        define_method('encrypt') do |attribute_name, unencrypted_value|
          setting = send("#{attribute_name}_encryption_setting")
          encryptor = send("#{attribute_name}_encryptor")
          encrypted_value = encryptor.encrypt(
            unencrypted_value,
            purpose: setting.purpose
          )
          send("#{attribute_name}_encrypted=", encrypted_value)
        end
      end

      def define_decrypt
        define_method('decrypt') do |attribute_name|
          encrypted_value = send("#{attribute_name}_encrypted")
          return nil unless encrypted_value

          setting = send("#{attribute_name}_encryption_setting")
          send("#{attribute_name}_encryptor")
            .decrypt(encrypted_value, purpose: setting.purpose)
        end
      end

      def define_attribute_accessors(attribute_name, options = {})
        define_attribute_encryption_setting(attribute_name, options)
        define_attribute_encryptor(attribute_name)
        define_attribute_setter(attribute_name)
        define_attribute_getter(attribute_name)
      end

      def define_attribute_encryption_setting(attribute_name, options = {})
        define_method("#{attribute_name}_encryption_setting") do
          instance_variable_name = "@#{attribute_name}_encryption_setting"
          instance_variable = instance_variable_get(instance_variable_name)
          return instance_variable if instance_variable

          instance_variable_set(
            instance_variable_name,
            EncryptionSetting::Record.merge(self.class.encryption_setting,
                                            options)
          )
        end
      end

      def define_attribute_encryptor(attribute_name)
        define_method("#{attribute_name}_encryptor") do
          instance_variable_name = "@#{attribute_name}_encryptor"
          instance_variable_get(instance_variable_name) ||
            instance_variable_set(
              instance_variable_name,
              Encryptor.new(
                send("#{attribute_name}_encryption_setting")
              )
            )
        end
      end

      def define_attribute_setter(attribute_name)
        define_method("#{attribute_name}=") do |unencrypted_value|
          # Save unencrypted value in instance variable to not have to
          # decrypt a freshly encrypted value.
          instance_variable_set("@#{attribute_name}", unencrypted_value)
          unless unencrypted_value
            return send("#{attribute_name}_encrypted=", nil)
          end

          encrypt(attribute_name, unencrypted_value)
          unencrypted_value
        end
      end

      def define_attribute_getter(attribute_name)
        define_method(attribute_name) do
          # Check if an instance variable with the decrypted value already
          # exist to save decryption time. Otherwise, call the generic
          # #decrypt method.
          instance_variable = instance_variable_get("@#{attribute_name}")
          return instance_variable if instance_variable

          decrypted_value = decrypt(attribute_name)
          # Save the result to not have to decrypt it again.
          instance_variable_set("@#{attribute_name}", decrypted_value)
        end
      end
    end
  end
end
