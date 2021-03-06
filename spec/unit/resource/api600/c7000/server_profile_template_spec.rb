require 'spec_helper'

RSpec.describe OneviewSDK::API600::C7000::ServerProfileTemplate do
  include_context 'shared context'

  it 'inherits from API500' do
    expect(described_class).to be < OneviewSDK::API500::C7000::ServerProfileTemplate
  end

  describe '#initialize' do
    it 'sets the type correctly' do
      item = described_class.new(@client_600, name: 'server_profile_template')
      expect(item[:type]).to eq('ServerProfileTemplateV4')
    end
  end

  describe '#get_available_networks' do
    it 'retrieves list of networks' do
      item = described_class.new(@client_600)
      expect(@client_600).to receive(:rest_get).with("#{described_class::BASE_URI}/available-networks?queryTest=Test")
                                               .and_return(FakeResponse.new('it' => 'Networks'))
      expect(item.get_available_networks(@client_600, 'query_test' => 'Test')['it']).to eq('Networks')
    end
  end
end
