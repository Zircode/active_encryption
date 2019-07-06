# frozen_string_literal: true

require 'rails/generators/base'

module ActiveEncryption
  module Generators
    # Generator to install ActiveEncryption in a Rails application.
    #
    # Usage:
    #
    #  ``rails generate active_encryption:install``
    #
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __dir__)

      desc <<~DESCRIPTION
        Creates a ActiveEncryption initializer and copy\
        encryption_settings.yml file to your application.
      DESCRIPTION

      def copy_initializer
        copy_file(
          'active_encryption.rb',
          Rails.root.join('config', 'initializers', 'active_encryption.rb')
        )
      end

      def copy_encryption_settings
        file_path = Rails.root.join('config', 'encryption_settings.yml')
        copy_file 'encryption_settings.yml', file_path
        gsub_file file_path,
                  '*RANDOM_SALT*',
                  SecureRandom.urlsafe_base64(4)
      end
    end
  end
end
