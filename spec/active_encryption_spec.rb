# frozen_string_literal: true

RSpec.describe ActiveEncryption do
  it 'has a version number' do
    expect(ActiveEncryption::VERSION).not_to be nil
  end

  it 'has a immutable version number' do
    expect(ActiveEncryption::VERSION).to be_frozen
  end
end
