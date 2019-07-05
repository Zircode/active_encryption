# frozen_string_literal: true

RSpec.describe ActiveEncryption::Encryptor do
  subject(:encryptor) do
    described_class.new(setting)
  end

  let(:data) { 'Lorem ipsum.' }
  let(:setting) do
    instance_double(
      'ActiveEncryptio::EncryptionSetting::Record',
      key: ['fc27192c31cb0602bd41c62d676d7ddf'].pack('H*'),
      cipher: 'aes-128-gcm',
      digest: 'SHA256',
      serializer: Marshal
    )
  end
  let(:service_args) do
    [
      setting.key,
      cipher: setting.cipher,
      digest: setting.digest,
      serializer: setting.serializer
    ]
  end
  let(:service) do
    ActiveSupport::MessageEncryptor.new(*service_args)
  end

  describe '#encrypt' do
    it 'encrypts data' do
      encrypted = encryptor.encrypt(data)
      expect(encrypted.bytesize).to eq 76
    end

    it 'encrypts the same data differently each time' do
      expect(encryptor.encrypt(data)).not_to be eq encryptor.encrypt(data)
    end

    it 'initializes ActiveSupport::MessageEncryptor' do
      service_instance = service
      allow(service.class).to receive(:new) { service_instance }
      encryptor.encrypt(data)
      expect(service.class).to have_received(:new).once.with(*service_args)
    end

    it 'calls ActiveSupport::MessageEncryptor#encrypt_and_sign' do
      allow(service).to receive(:encrypt_and_sign)
      args = [data, expires_at: 123, expires_in: 456, purpose: 'something']
      described_class.new(setting, service).encrypt(*args)
      expect(service).to have_received(:encrypt_and_sign).once.with(*args)
    end
  end

  describe '#decrypt' do
    it 'decrypts encrypted data' do
      expect(encryptor.decrypt(encryptor.encrypt(data))).to eq data
    end

    it 'calls ActiveSupport::MessageEncryptor#decrypt_and_verify' do
      allow(service).to receive(:decrypt_and_verify)
      args = ['Encrypted data', purpose: 'something']
      described_class.new(setting, service).decrypt(*args)
      expect(service).to have_received(:decrypt_and_verify).once.with(*args)
    end
  end
end
