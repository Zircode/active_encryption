# ActiveEncryption

ActiveEncryption transparently encrypt (and decrypt!) attributes. It works with any class, but it's primarly intended to be used with ActiveRecord models. Under the hood, it doesn't reinvent the wheel and uses the tried and tested ActiveSupport::MessageEncryptor.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'active_encryption'
```

And then execute:

```shell
bundle
```

Or install it yourself as:

```shell
gem install active_encryption
```

### Rails

ActiveEncryption works with Ruby on Rails 5.0 or higher.

## Usage

```ruby
class User
  encrypted_attr :ssn
end
```

Or if you're using ActiveRecord:

```ruby
class User < ApplicationRecord
  encrypted_attr :ssn
end
```

In this example, ActiveEncryption assumes that you have an attribute
``ssn_encrypted``.
Therefore, you might need a database migration:

```ruby
class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :ssn_encrypted

      t.timestamps
    end
  end
end
```

When storing your encrypted data, please consider the length requirements
of the database column where you're storing the encrypted data.

## Configuration

```ruby
# frozen_string_literal: true

ActiveEncryption.configure do |config|
  # Store containing the encryption settings
  # Use "config/encryption_settings.yml" to store the settings:
  config.encryption_setting_store =
    ActiveEncryption::EncryptionSetting::YamlStore.new(
      '/path/encryption_settings.yml' # CHANGE ME
    )

  # ID of the encryption setting to use by default:
  config.default_encryption_setting_id = :default
end
```

You also need a ``encryption_settings.yml`` file:

```yaml
# WARNING: Changing these encryption settings prevents the decryption
# of already encrypted data.

# Default encryption setting
default:
  # secret: must be a cryptographically random string.
  # The secret is hashed with PBKDF2 to generate the encryption key.
  #
  # You can generate one with:
  # - "rails secret"
  # - SecureRandom.hex(64)
  # - or, SecureRandom.urlsafe_base64(64)
  #
  ## WARNING ##
  # The secret value should NOT be stored in this file directly.
  # You should instead refer to where the secret value is stored
  # e.g. refer to Rails credentials/secrets, an environment variable or
  # a KMS/HSM, etc.
  secret: <%= ENV['SECRET_KEY'] %>
  # Salt used to generate the encryption key based on the secret
  secret_salt: 'ActiveEncryption salt: RANDOM_SALT' # CHANGE ME
  # Number of iterations for PBKDF2 on the secret.
  secret_iterations: 65536
  # Cipher to use. Can be any cipher returned by OpenSSL::Cipher.ciphers.
  cipher: aes-256-gcm
  # Digest to use to sign. Default is SHA1. Recommended is SHA256.
  # Ignored when using an AEAD cipher like 'aes-256-gcm'.
  digest: SHA256
```

### Encryption setting

The following attributes are configurable in an encryption setting:

| Attribute       | Description | Default value |
|-----------------|-------------|---------------|
| ``cipher``      | String with the encryption cipher to use. Can be any cipher returned by OpenSSL::Cipher.ciphers. | 'aes-256-gcm' |
| ``digest``      | String with the digest to use to sign. Ignored when using an AEAD cipher like 'aes-256-gcm'. | 'SHA1' |
| ``id``          | Unique ID to identify an encryption setting. It can be an Integer, String, or Symbol. | nil |
| ``key``         | Cryptographicaly random binary string of the exact size required by the cipher. E.g. 'aes-256-gcm' requires 32 bytes (256 bits). Can be generated with ``SecureRandom.bytes(32)``. It is STRONGLY recommended NOT to set this directly but to use a secret for key derivation. | nil |
| ``purpose``     | Confines the encrypted attribute to a specific purpose. See https://api.rubyonrails.org/classes/ActiveSupport/MessageEncryptor.html#method-i-encrypt_and_sign | nil |
| ``secret``      | String used to derive an encryption key with PBKDF2. Can be generated with ``SecureRandom.hex(64)`` or ``SecureRandom.urlsafe_base64(64)``. | nil |
| ``secret_iterations`` | Number of iterations of PBKDF2 to derive the key from the secret. See https://api.rubyonrails.org/classes/ActiveSupport/KeyGenerator.html | 65536 |
| ``secret_salt`` | Salt for PBKDF2 to derive the key from the secret. | 'ActiveEncryption default key salt' |
| ``serializer``  | Object serializer to use. E.g.: 'YAML'. | Marshal |

Keys or secrets must NEVER be stored in version control (e.g. git) or in the
database in an unencrypted form.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.
To release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push git
commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on
[GitHub](https://github.com/Zircode/active_encryption). This project is intended
to be a safe, welcoming space for collaboration, and contributors are expected
to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of
conduct.

## License

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ActiveEncryption project’s codebases, issue trackers,
chat rooms and mailing lists is expected to follow the
[code of conduct](https://github.com/Zircode/active_encryption/blob/master/CODE_OF_CONDUCT.md).
