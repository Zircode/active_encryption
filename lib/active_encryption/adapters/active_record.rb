# frozen_string_literal: true

module ActiveEncryption
  module Adapters
    # Encapsulates the ActiveRecord adapter
    class ActiveRecord
      def initialize
        ActiveSupport.on_load(:active_record) do
          extend ActiveEncryption::Encryptable
        end
      end
    end
  end
end

ActiveEncryption::Adapters::ActiveRecord.new
