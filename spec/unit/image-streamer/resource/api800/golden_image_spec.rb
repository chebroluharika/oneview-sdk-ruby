require 'spec_helper'

klass = OneviewSDK::ImageStreamer::API800::GoldenImage
RSpec.describe klass do
  include_context 'shared context'

  it 'inherits from API600' do
    expect(described_class).to be < OneviewSDK::ImageStreamer::API600::GoldenImage
  end
end
