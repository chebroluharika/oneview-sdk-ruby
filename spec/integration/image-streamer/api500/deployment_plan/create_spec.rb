# (C) Copyright 2018 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

require 'spec_helper'

klass = OneviewSDK::ImageStreamer::API500::DeploymentPlan
RSpec.describe klass, integration_i3s: true, type: CREATE, sequence: i3s_seq(klass) do
  include_context 'integration i3s api500 context'

  before :all do
    @build_plan = OneviewSDK::ImageStreamer::API500::BuildPlan.find_by($client_i3s_500, name: BUILD_PLAN1_NAME).first
    @golden_image = OneviewSDK::ImageStreamer::API500::GoldenImage.find_by($client_i3s_500, name: GOLDEN_IMAGE1_NAME).first
  end

  describe '#create' do
    it 'creates a deployment plan basic' do
      options = {
        name: DEPLOYMENT_PLAN1_NAME,
        description: 'AnyDescription',
        hpProvided: false,
        oeBuildPlanURI: @build_plan['uri']
      }

      item = klass.new($client_i3s_500, options)
      expect { item.create! }.not_to raise_error
      item.retrieve!
      expect(item['uri']).to be
      expect(item['name']).to eq(options[:name])
      expect(item['description']).to eq(options[:description])
      expect(item['hpProvided']).to eq(options[:hpProvided])
      expect(item['oeBuildPlanURI']).to eq(@build_plan['uri'])
    end

    it 'creates a deployment plan with golden image' do
      options = {
        name: DEPLOYMENT_PLAN2_NAME,
        description: 'AnyDescription',
        hpProvided: false,
        oeBuildPlanURI: @build_plan['uri'],
        goldenImageURI: @golden_image['uri']
      }

      item = klass.new($client_i3s_500, options)
      expect { item.create! }.not_to raise_error
      item.retrieve!
      expect(item['uri']).to be
      expect(item['name']).to eq(options[:name])
      expect(item['description']).to eq(options[:description])
      expect(item['hpProvided']).to eq(options[:hpProvided])
      expect(item['oeBuildPlanURI']).to eq(@build_plan['uri'])
      expect(item['goldenImageURI']).to eq(@golden_image['uri'])
    end

    it 'creates a deployment plan with custom attributes' do
      build_plan = OneviewSDK::ImageStreamer::API500::BuildPlan.find_by($client_i3s_500, name: BUILD_PLAN4_NAME).first
      options = {
        name: DEPLOYMENT_PLAN3_NAME,
        description: 'AnyDescription',
        hpProvided: false,
        oeBuildPlanURI: build_plan['uri'],
        customAttributes: [{ 'name' => 'DomainName', 'type' => 'String', 'value' => 'fake.com' }]
      }

      item = klass.new($client_i3s_500, options)
      expect { item.create! }.not_to raise_error
      item.retrieve!
      expect(item['uri']).to be
      expect(item['name']).to eq(options[:name])
      expect(item['description']).to eq(options[:description])
      expect(item['hpProvided']).to eq(options[:hpProvided])
      expect(item['oeBuildPlanURI']).to eq(build_plan['uri'])
      expect(item['customAttributes'].first['name']).to eq(options[:customAttributes].first['name'])
      expect(item['customAttributes'].first['type']).to eq(options[:customAttributes].first['type'])
      expect(item['customAttributes'].first['value']).to eq(options[:customAttributes].first['value'])
    end
  end

  describe '#get_used_by' do
    it 'raises exception when uri is empty' do
      item = klass.new($client_i3s_500)
      expect { item.get_used_by }.to raise_error(OneviewSDK::IncompleteResource, /Please set uri attribute/)
    end

    it 'gets the details of the OS Deployment Plan' do
      item = klass.find_by($client_i3s_500, {}).first
      expect(item['uri']).to be
      expect { item.get_used_by }.not_to raise_error
    end
  end
end
