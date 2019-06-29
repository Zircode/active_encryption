# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_encryption/version'

Gem::Specification.new do |spec|
  spec.name          = 'active_encryption'
  spec.version       = ActiveEncryption::VERSION
  spec.authors       = ['Arnaud Germis']
  spec.email         = ['hello@zircode.com', 'arnaud@zircode.com']

  spec.summary       = <<~SUMMARY
    ActiveEncryption transparently encrypt (and decrypt!) attributes with\
    ActiveSupport::MessageEncryptor
  SUMMARY
  spec.homepage      = 'https://github.com/Zircode/active_encryption'
  spec.license       = 'MIT'

  spec.metadata['homepage_uri']    = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/Zircode/active_encryption'
  spec.metadata['changelog_uri']   = 'https://github.com/Zircode/active_encryption/CHANGELOG.md'
  spec.metadata['bug_tracker_uri'] = 'https://github.com/Zircode/active_encryption/issues'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added
  # into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0")
                     .reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.3'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'reek', '~> 5.4.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.72.0'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.33.0'
  spec.add_development_dependency 'simplecov', '~> 0.17.0'
end
