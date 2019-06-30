# frozen_string_literal: true

RSpec.describe ActiveEncryption do
  it 'has a version number' do
    expect(ActiveEncryption::VERSION).not_to be nil
  end

  it 'has a immutable version number' do
    expect(ActiveEncryption::VERSION).to be_frozen
  end

  describe '.config' do
    it 'returns the gem configuration' do
      expect(described_class.config).not_to be nil
    end
  end

  describe '.configure' do
    it 'sets the configuration' do
      described_class.configure do |config|
        expect(config).not_to be eq(described_class.config)
      end
    end
  end
end
