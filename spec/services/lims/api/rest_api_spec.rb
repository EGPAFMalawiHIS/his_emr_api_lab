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
        tracking_number: 'XLABX26721',
        sample_type: 'Blood'
      )
    end
    let(:payload) do
      {
        order: { tracking_number: 'XLABX26721' },
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

  # Round trip against a real NLIMS: pushes an order that already carries a
  # verified viral load result, then pulls it back with the same client calls
  # the pull worker uses. Opt-in, because it writes an order to that NLIMS:
  #
  #   NLIMS_URL=http://host:3009 NLIMS_USERNAME=... NLIMS_PASSWORD=... \
  #     bundle exec rspec spec/services/lims/api/rest_api_spec.rb
  describe 'push and pull against a live NLIMS', :nlims do
    subject(:api) do
      uri = URI(ENV.fetch('NLIMS_URL'))
      described_class.new(protocol: uri.scheme, host: uri.host, port: uri.port,
                          username: ENV.fetch('NLIMS_USERNAME'), password: ENV.fetch('NLIMS_PASSWORD'))
    end

    let(:tracking_number) { "XLAB#{Time.now.strftime('%y%m%d%H%M%S')}#{rand(10..99)}" }
    let(:drawn_at) { Time.now - 1.hour }
    let(:verified_at) { (drawn_at + 30.minutes).strftime('%Y-%m-%d %H:%M:%S') }
    let(:lab_user) { { first_name: 'Lab', last_name: 'Spec', id: 'lab_spec', phone_number: '' } }

    let(:order_dto) do
      Lab::Lims::OrderDto.new(_id: tracking_number, tracking_number:, sample_type: 'Plasma')
    end

    # Payload accepted by NLIMS POST /api/v2/orders (Api::V2::OrdersController#create).
    # Tests may carry a status trail and results; NLIMS saves the results
    # when the test status is 'verified'.
    let(:payload) do
      {
        order: {
          tracking_number:,
          district: 'Lilongwe',
          sending_facility: 'Kamuzu Central Hospital',
          requested_by: 'Lab Spec',
          sample_type: { name: 'Plasma', nlims_code: 'NLIMS_SP_0017_MWI' },
          date_created: drawn_at.strftime('%Y-%m-%d %H:%M:%S'),
          sample_status: { name: 'specimen_collected' },
          priority: 'Routine',
          target_lab: 'Kamuzu Central Hospital',
          order_location: 'ART',
          drawn_by: { id: 'lab_spec', name: 'Lab Spec', phone_number: '' }
        },
        patient: {
          national_patient_id: 'LABSPEC1',
          first_name: 'Lab',
          last_name: 'Spec',
          gender: 'F',
          date_of_birth: '1990-01-01',
          phone_number: ''
        },
        tests: [
          {
            test_type: { name: 'HIV Viral Load', nlims_code: 'NLIMS_TT_0071_MWI' },
            test_status: 'verified',
            time_updated: verified_at,
            status_trail: %w[pending started completed verified].each_with_index.map do |status, step|
              { status:, timestamp: (drawn_at + (step * 10).minutes).strftime('%Y-%m-%d %H:%M:%S'), updated_by: lab_user }
            end,
            test_results: [
              {
                measure: { name: 'Viral Load', nlims_code: 'NLIMS_TT_0071_MWI' },
                result: { value: '1250', unit: 'copies/mL', result_date: verified_at }
              }
            ]
          }
        ]
      }
    end

    before do
      skip 'Set NLIMS_URL, NLIMS_USERNAME and NLIMS_PASSWORD to run' unless ENV.values_at('NLIMS_URL', 'NLIMS_USERNAME',
                                                                                        'NLIMS_PASSWORD').all?(&:present?)

      api.send(:authentication_token=, nil)
      # The payload is built here rather than from a local EMR order, so the
      # spec does not depend on the host's concept dictionary.
      allow(api).to receive(:make_create_params).with(order_dto).and_return(payload)
    end

    it 'pushes an order with results and pulls the results back' do
      pushed = api.create_order(order_dto)
      expect(pushed[:tracking_number]).to eq(tracking_number)

      pulled_order = api.send(:find_lims_order, tracking_number)
      expect(pulled_order.dig('order', 'tracking_number')).to eq(tracking_number)

      pulled_tests = api.send(:find_lims_results, tracking_number)
      pulled_dto = Lab::Lims::OrderDto.new(tracking_number:)
      api.send(:patch_order_dto_with_lims_results!, pulled_dto, pulled_tests)

      expect(pulled_dto.dig('test_results', 'HIV Viral Load', 'results', 'Viral Load', 'result_value')).to eq('1250')
    end
  end
end
