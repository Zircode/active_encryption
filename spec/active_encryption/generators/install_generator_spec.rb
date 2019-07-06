# frozen_string_literal: true

require 'rails/generators'
require 'tmpdir'
require 'pathname'
require 'generators/active_encryption/install_generator'

RSpec.describe ActiveEncryption::Generators::InstallGenerator do
  before do
    allow(Rails).to receive(:root) { tmpdir }
    # Silence STDOUT before invoking the generator
    orig_stdout = $stdout.clone
    $stdout.reopen File.open(File::NULL, 'w')
    Rails::Generators.invoke('active_encryption:install')
    # Restore STDOUT
    $stdout.reopen orig_stdout
  end

  after do
    FileUtils.remove_entry tmpdir
  end

  let(:tmpdir) { Pathname.new(Dir.mktmpdir) }

  it 'creates the active_encryption.rb initializer' do
    file_path = tmpdir.join('config', 'initializers', 'active_encryption.rb')
    expect(File.read(file_path))
      .to include 'ActiveEncryption.configure do |config|'
  end

  it 'creates the encryption_settings.yml config file' do
    file_path = tmpdir.join('config', 'encryption_settings.yml')
    expect(File.read(file_path))
      .to include 'secret: '
  end

  it 'adds a random salt to encryption_settings.yml' do
    file_path = tmpdir.join('config', 'encryption_settings.yml')
    expect(File.read(file_path))
      .to match(/ActiveEncryption salt: [a-zA-Z\d_\-]{6}/)
  end
end
