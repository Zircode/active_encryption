# frozen_string_literal: true

RSpec.describe ActiveEncryption::Encryptable do
  subject(:record) { klass.new }

  before do
    allow(ActiveEncryption).to receive(:config) do
      config = ActiveEncryption::Configuration::Store.new
      config.encryption_setting_store =
        ActiveEncryption::EncryptionSetting::YamlStore.new(
          'encryption_settings.yml'
        )
      allow(config.encryption_setting_store).to receive(:content)
        .and_return setting

      config
    end
  end

  let(:setting) do
    {
      default: {
        secret: 'My top secret secret',
        secret_iterations: 5,
        secret_salt: 'My salt',
        cipher: 'aes-128-gcm'
      }
    }
  end
  let(:klass) do
    Class.new do
      extend ActiveEncryption::Encryptable

      attr_accessor :test1_encrypted, :test2_encrypted
      encrypted_attr :test1
      encrypted_attr :test2, cipher: 'aes-256-gcm', purpose: 'My purpose'
    end
  end
  let(:attribute_value) { 'foo' }

  describe '.encryption_setting' do
    it 'checks the configuration' do
      klass.encryption_setting
      expect(ActiveEncryption)
        .to have_received(:config)
    end

    it 'returns the encryption setting from the configuration' do
      expect(klass.encryption_setting).to have_attributes(
        setting[:default]
      )
    end
  end

  describe '.encrypted_attr' do
    it 'defines attribute accessors' do
      record.test1 = attribute_value
      expect(record.test1).to eq attribute_value
    end
  end

  describe '#encrypt' do
    it 'encrypts the encrypted attribute with the value' do
      expect(record.encrypt(:test1, 123)).not_to be nil
    end
  end

  describe '#decrypt' do
    subject(:record_with_encrypted_attribute) do
      record.test1_encrypted = encrypted_attribute_value
      record
    end

    let(:encrypted_attribute_value) do
      encryptor = ActiveEncryption::Encryptor.new(
        ActiveEncryption::EncryptionSetting::Record.new(setting[:default])
      )
      encryptor.encrypt(attribute_value)
    end

    it 'decrypts the encrypted attribute value' do
      expect(record_with_encrypted_attribute.decrypt(:test1))
        .to eq attribute_value
    end

    context 'when the encrypted attribute is nil' do
      let(:encrypted_attribute_value) { nil }

      it 'returns nil' do
        expect(record_with_encrypted_attribute.decrypt(:test1)).to be nil
      end
    end

    context 'when the encrypted attribute is invalid' do
      let(:encrypted_attribute_value) { 'invalid' }

      it 'raises an exception' do
        expect { record_with_encrypted_attribute.decrypt(:test1) }
          .to raise_error(
            ActiveSupport::MessageEncryptor::InvalidMessage
          )
      end
    end
  end

  describe '#attribute=' do
    subject(:record_with_attribute_value) do
      record.test1 = attribute_value
      record
    end

    it 'encrypts the attribute value' do
      expect(record_with_attribute_value.test1_encrypted).not_to be nil
    end

    context 'when the attribute value is nil' do
      let(:attribute_value) { nil }

      it 'sets the the encrypted attribute to nil' do
        expect(record_with_attribute_value.test1_encrypted).to be nil
      end
    end
  end

  describe '#attribute' do
    it 'decrypts the encrypted attribute value' do
      other_record = klass.new
      other_record.test1 = attribute_value
      record.test1_encrypted = other_record.test1_encrypted
      expect(record.test1).to eq other_record.test1
    end
  end

  describe '#attribute_encryption_setting' do
    it 'returns the default encryption setting' do
      expect(record.test1_encryption_setting).to have_attributes(
        setting[:default]
      )
    end

    context 'when the default setting is overriden' do
      it 'returns the default and overriden settings merged' do
        expect(record.test2_encryption_setting).to have_attributes(
          setting[:default].merge(cipher: 'aes-256-gcm', purpose: 'My purpose')
        )
      end
    end
  end

  describe '#attribute_encryptor' do
    it 'returns an encryptor with the encryption setting' do
      expect(record.test2_encryptor.encryption_setting)
        .to eq record.test2_encryption_setting
    end
  end
end
