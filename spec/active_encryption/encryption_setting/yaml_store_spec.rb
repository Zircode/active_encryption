# frozen_string_literal: true

RSpec.describe ActiveEncryption::EncryptionSetting::YamlStore do
  before do
    allow(File).to receive(:read).with(file_path)
                                 .and_return(content)
  end

  let(:file_path) { '/path/file.yml' }
  let(:id) { :default }
  let(:content) do
    'default:
       foo: 1
       bar: 2'
  end
  let(:store) { described_class.new(file_path) }

  describe '#find' do
    it 'returns an existing item' do
      expect(store.find(id)).to be_truthy
    end

    it 'sets the ID of the returned item' do
      record = store.find(id)
      expect(record.id).to eq id
    end

    it 'returns nil for non-existent item' do
      expect(store.find(:non_existent)).to be nil
    end
  end

  describe '#content' do
    it 'loads the YAML file once only' do
      store.find(:something)
      store.find(:something_else)
      expect(File).to have_received(:read).once
    end

    it 'deep symbolizes YAML string keys' do
      expected = { default: { foo: 1, bar: 2 } }
      expect(store.content).to eq expected
    end

    context 'when the content has ERB tags' do
      let(:content) do
        'default:
           foo: <%= 1 + 2 %>'
      end

      it 'interprets the ERB template' do
        expected = { default: { foo: 3 } }
        expect(store.content).to eq expected
      end
    end
  end

  describe '#file_path' do
    it 'returns the file path' do
      expect(store.file_path).to eq file_path
    end
  end
end
