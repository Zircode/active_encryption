# frozen_string_literal: true

RSpec.describe ActiveEncryption::EncryptionSetting::Record do
  subject(:record) do
    described_class.new(
      cipher: attributes[:cipher],
      digest: attributes[:digest],
      id: attributes[:id],
      key: attributes[:key],
      purpose: attributes[:purpose],
      secret: attributes[:secret],
      secret_salt: attributes[:secret_salt],
      secret_iterations: attributes[:secret_iterations],
      serializer: attributes[:serializer]
    )
  end

  let(:expected_key) { ['97a231811a666855bda3f6eadb6f1749'].pack('H*') }
  let(:key) { expected_key }
  let(:serializer) { Marshal }
  let(:attributes) do
    {
      cipher: 'aes-128-gcm',
      digest: 'SHA256',
      id: 'my_id',
      key: key,
      purpose: 'something',
      secret: 'My secret',
      secret_salt: 'My salt',
      secret_iterations: 3,
      serializer: serializer
    }
  end

  %w[cipher digest id key purpose secret
     secret_iterations secret_salt serializer].each do |method_name|
    describe "##{method_name}" do
      it "returns the #{method_name}" do
        expected = attributes[method_name.to_sym]
        expect(record.public_send(method_name)).to eq expected
      end
    end
  end

  context 'when the key is not set' do
    let(:key) { nil }

    it 'computes the key' do
      expect(record.key).to eq expected_key
    end
  end

  context 'when the serializer is a String' do
    let(:serializer) { 'YAML' }

    it 'returns the class represented' do
      expect(record.serializer).to eq YAML
    end
  end

  describe '#to_h' do
    it 'returns a hash with the attributes' do
      expect(record.to_h).to eq attributes
    end
  end

  describe '.to_h' do
    context 'when the record is a Hash' do
      it 'filters the invalid hash keys' do
        expected = { cipher: 456 }
        expect(
          described_class.to_h(foo: 123, cipher: 456, bar: 789)
        ).to eq expected
      end

      it 'keeps the valid hash keys' do
        expect(described_class.to_h(attributes)).to eq attributes
      end
    end

    context 'when the record is not a Hash' do
      it 'converts it to a hash' do
        expect(described_class.to_h(record)).to eq attributes
      end
    end
  end

  describe '.merge' do
    it 'merges the records' do
      new_hash = { id: 'other_id', key: key, purpose: 'new purpose' }
      expected = described_class.new(attributes.merge(new_hash))
      expect(described_class.merge(record, new_hash).to_h).to eq expected.to_h
    end

    it 'resets the computed encryption key' do
      new_hash = { id: 'other_id', secret: 'New secret' }
      expect(described_class.merge(record, new_hash).key).not_to eq record.key
    end
  end
end
