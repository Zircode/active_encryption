# frozen_string_literal: true

RSpec.describe ActiveEncryption::EncryptionSetting::Key do
  let(:secret) { 'My Secret' }

  it 'has a default salt' do
    expected = 'ActiveEncryption default key salt'
    expect(described_class::DEFAULT_SALT).to eq expected
  end

  describe '#salt' do
    context 'when salt is set' do
      let(:salt) { 'My custom salt' }

      it 'returns the set salt' do
        expect(described_class.new(secret, salt: salt).salt).to eq salt
      end
    end

    context 'when salt is not set' do
      it 'returns the default salt' do
        expected = described_class::DEFAULT_SALT
        expect(described_class.new(secret).salt).to eq expected
      end
    end
  end

  shared_examples 'cipher and key length' do
    describe '#cipher' do
      it 'returns the set cipher' do
        expect(described_class.new(secret, cipher: cipher).cipher).to eq cipher
      end
    end

    describe '#length' do
      it 'returns the length in bytes' do
        expect(described_class.new(
          secret,
          cipher: cipher
        ).length).to eq length_in_bytes
      end
    end
  end

  context 'when the cipher is AES 256 bits' do
    let(:cipher) { 'aes-256-gcm' }
    let(:length_in_bytes) { 32 }

    include_examples 'cipher and key length'
  end

  context 'when the cipher is AES 128 bits' do
    let(:cipher) { 'aes-128-cbc' }
    let(:length_in_bytes) { 16 }

    include_examples 'cipher and key length'
  end

  describe '#iterations' do
    let(:iterations) { 123_456 }

    it 'returns the number of iterations' do
      expect(described_class.new(
        secret,
        iterations: iterations
      ).iterations).to eq iterations
    end
  end

  describe '#value' do
    let(:salt) { 'My custom salt' }
    let(:cipher) { 'aes-128-gcm' }
    let(:iterations) { 123 }
    let(:key_value) do
      described_class.new(
        secret,
        salt: salt,
        cipher: cipher,
        iterations: iterations
      ).value
    end
    let(:new_secret) { secret }
    let(:new_salt) { salt }
    let(:new_cipher) { cipher }
    let(:new_iterations) { iterations }
    let(:new_key_value) do
      described_class.new(
        new_secret,
        salt: new_salt,
        cipher: new_cipher,
        iterations: new_iterations
      ).value
    end

    let(:key_hex_value) do
      'fae27de306a5ca010fc6bf71a7541bf4'
    end

    it 'returns the correct key' do
      expect(key_value.unpack('H*').first).to eq key_hex_value
    end

    shared_examples 'same key value' do
      it 'returns the same key' do
        expect(new_key_value).to eq key_value
      end
    end

    shared_examples 'different key value' do
      it 'returns a different key' do
        expect(new_key_value).not_to eq key_value
      end
    end

    context 'when the settings are the same' do
      include_examples 'same key value'
    end

    context 'when the secret is the same' do
      let(:secret) { 'My top secret secret' }

      include_examples 'same key value'
    end

    context 'when the secret changes' do
      let(:new_secret) { 'New secret' }

      include_examples 'different key value'
    end

    context 'when the cipher size is the same' do
      let(:cipher) { 'aes-128-gcm' }
      let(:new_cipher) { 'aes-128-cbc' }

      include_examples 'same key value'
    end

    context 'when the cipher size changes' do
      let(:new_cipher) { 'aes-256-gcm' }

      include_examples 'different key value'
    end

    context 'when the salt is the same' do
      let(:salt) { 'New key salt' }

      include_examples 'same key value'
    end

    context 'when the salt changes' do
      let(:new_salt) { 'My other salt' }

      include_examples 'different key value'
    end

    context 'when the iterations are the same' do
      let(:iterations) { 42 }

      include_examples 'same key value'
    end

    context 'when the iterations change' do
      let(:new_iterations) { 100 }

      include_examples 'different key value'
    end
  end
end
