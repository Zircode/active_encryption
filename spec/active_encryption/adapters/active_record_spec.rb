# frozen_string_literal: true

RSpec.describe ActiveEncryption::Adapters::ActiveRecord do
  before do
    unless defined?(ActiveRecord::Base)
      ActiveRecord = Module.new
      # Mocks ActiveRecord::Base without loading AR
      ActiveRecord::Base = Class.new(Object)
      ActiveSupport.run_load_hooks(:active_record, ActiveRecord::Base)
    end
  end

  context 'when ActiveRecord is loaded' do
    it 'responds to .encrypted_attr' do
      expect(ActiveRecord::Base).to respond_to(:encrypted_attr)
    end

    it 'responds to .encryption_setting' do
      expect(ActiveRecord::Base).to respond_to(:encryption_setting)
    end
  end
end
