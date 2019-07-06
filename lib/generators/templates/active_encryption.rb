# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

ActiveEncryption.configure do |config|
  # Store containing the encryption settings
  # Use "config/encryption_settings.yml" to store the settings:
  config.encryption_setting_store =
    ActiveEncryption::EncryptionSetting::YamlStore.new(
      Rails.root.join('config', 'encryption_settings.yml')
    )

  # ID of the encryption setting to use by default:
  # config.default_encryption_setting_id = :default
end
