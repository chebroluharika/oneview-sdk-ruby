require 'spec_helper'

klass = OneviewSDK::API500::Synergy::Fabric
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  let(:current_client) { $client_500_synergy }
  include_examples 'FabricDeleteExample', 'integration api500 context'
end
