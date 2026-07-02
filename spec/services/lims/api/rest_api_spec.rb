# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lab::Lims::Api::RestApi do
  subject(:api) do
    described_class.new(protocol: 'http', host: 'lims.example', port: 3010,
                        username: 'user', password: 'password')
  end

  describe '#create_order' do
    let(:order_dto) do
      ActiveSupport::HashWithIndifferentAccess.new(
        tracking_number: 'XBHC26721',
        sample_type: 'Blood'
      )
    end
    let(:payload) do
      {
        order: { tracking_number: 'XBHC26721' },
        patient: { first_name: 'Test' },
        tests: [
          { test_type: { name: 'Full Blood Count', nlims_code: 'NLIMS_TT_0035_MWI' } }
        ]
      }
    end
    let(:response) { double(body: { message: 'Order created' }.to_json) }

    before do
      allow(api).to receive(:in_authenticated_session)
        .and_yield('token' => 'abc', 'Content-type' => 'application/json')
        .and_return(response)
      allow(api).to receive(:make_create_params).with(order_dto).and_return(payload)
      allow(api).to receive(:update_order_results)
    end

    it 'posts nested order parameters as JSON' do
      expect(RestClient).to receive(:post).with(
        'http://lims.example:3010/api/v2/orders',
        payload.to_json,
        hash_including('Content-Type' => 'application/json', 'Accept' => 'application/json')
      ).and_return(response)

      api.create_order(order_dto)
    end
  end
end
