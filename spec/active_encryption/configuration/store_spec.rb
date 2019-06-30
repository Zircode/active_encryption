# frozen_string_literal: true

RSpec.describe ActiveEncryption::Configuration::Store do
  subject(:store) { described_class.new }

  it 'stores values' do
    expected = :some_symbol
    store.default_encryption_setting_id = expected
    expect(store.default_encryption_setting_id).to eq expected
  end

  describe '#reset' do
    it 'resets the configuration' do
      expected = :some_symbol
      store.default_encryption_setting_id = expected
      store.reset
      expect(store.default_encryption_setting_id).not_to eq expected
    end
  end
end
