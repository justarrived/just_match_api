# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Doxxer do
  class FakeModelWithoutFactory
    def name
      'FakeModelWithoutFactory'
    end
  end

  class FakeModel
    def name
      'FakeModel'
    end
  end

  class AnotherFakeModel
    def name
      'AnotherFakeModel'
    end
  end

  describe 'class method' do
    describe '#curl_for' do
      let(:base_url) { 'http://localhost:3000/api/v1/jobs' }

      it 'returns correct cURL for index path' do
        result = described_class.curl_for(name: 'jobs')
        expected = "$ curl -X GET #{base_url}.json -s | python -mjson.tool"
        expect(result).to eq(expected)
      end

      it 'returns correct cURL for show path' do
        result = described_class.curl_for(name: 'jobs', id: 1)
        expected = "$ curl -X GET #{base_url}/1.json -s | python -mjson.tool"
        expect(result).to eq(expected)
      end

      it 'returns correct cURL with auth' do
        result = described_class.curl_for(name: 'jobs', with_auth: true)
        auth = "-H 'Authorization: Token token=YOUR_TOKEN'"
        expected = "$ curl #{auth} -X GET #{base_url}.json -s | python -mjson.tool"
        expect(result).to eq(expected)
      end
    end

    describe '#read_example' do
      let(:start_string) { '# Response example' }

      it 'starts with correct string' do
        result = described_class.read_example(Skill).start_with?(start_string)
        expect(result).to eq(true)
      end

      it 'ends with JSON attributes for model' do
        result = described_class.read_example(Skill).gsub(start_string, '')
        expect(JSON.parse(result)['data']['id']).to eq('1')
      end
    end

    describe '#_factory_attributes' do
      it 'returns attributes for model' do
        result = described_class._factory_attributes(Skill)
        expect(result[:id]).to eq(1)
      end

      it 'returns attributes for model without _for_docs factory' do
        FactoryGirl.define do
          factory(:fake_model) { id 1 }
        end

        result = described_class._factory_attributes(FakeModel)
        expect(result[:id]).to eq(1)
      end

      it 'returns attributes for model _for_docs factory' do
        FactoryGirl.define do
          factory :another_fake_model do
            id 1
            factory(:another_fake_model_for_docs) { id 2 }
          end
        end

        result = described_class._factory_attributes(AnotherFakeModel)
        expect(result[:id]).to eq(2)
      end

      it 'raises error for non-existing factory' do
        err_msg = 'Factory not registered: fake_model_without_factory'
        expect do
          described_class._factory_attributes(FakeModelWithoutFactory)
        end.to raise_error(ArgumentError, err_msg)
      end

      it 're-raises unknown ArgumentError' do
        allow(FactoryGirl).to receive(:attributes_for) do
          raise ArgumentError, 'Test error'
        end

        expect do
          described_class._factory_attributes(FakeModel)
        end.to raise_error(ArgumentError, 'Test error')
      end
    end

    describe '#_format_model_name' do
      it 'returns correctly formatted model name for single example' do
        result = described_class._format_model_name(FakeModel)
        expect(result).to eq('fake_model')
      end

      it 'returns correctly formatted model name for plural example' do
        result = described_class._format_model_name(FakeModel, plural: true)
        expect(result).to eq('fake_models')
      end
    end

    describe '#_example_for' do
      it 'returns correct data for single example' do
        result = described_class._example_for(Skill, plural: false)
        expect(JSON.parse(result)['data']['id']).to eq('1')
      end

      it 'returns correct data for plural example' do
        result = described_class._example_for(Skill, plural: true)
        expect(JSON.parse(result)['data'][0]['id']).to eq('1')
      end
    end

    describe '#_response_filename' do
      it 'returns correct filename single' do
        result = described_class._response_filename(FakeModel, plural: false)
        expected = result.ends_with?('examples/responses/fake_model.json')
        expect(expected).to eq(true)
      end

      it 'returns correct filename plural' do
        result = described_class._response_filename(FakeModel, plural: true)
        expected = result.ends_with?('examples/responses/fake_models.json')
        expect(expected).to eq(true)
      end
    end
  end
end
