# frozen_string_literal: true

require 'SocketIO'

module Lab
  module Lims
    module Api
      ##
      # Retrieve results from LIMS only through a websocket
      class WsApi
        def initialize(config: nil)
          @config = config || load_config
          @results_queue = []
          @socket_disconnected = false
          @socket = initialize_socket
        end

        def consume_orders(**_kwargs)
          loop do
            results = fetch_results
            unless results
              Rails.logger.debug('No results available... Waiting for results...')
              sleep(5)
              next
            end

            Rails.logger.info("Received result for ##{results['tracking_number']}")
            order = find_order(results['tracking_number'])
            next unless order

            Rails.logger.info("Updating result for order ##{order.order_id}")
            yield make_order_dto(order, results), OpenStruct.new(last_seq: 1)
          end
        end

        private

        def load_config
          {}
        end

        def initialize_socket
          SocketIO.connect('http://localhost:3011') do
            before_start do
              on_event('results') do
                Rails.logger.debug("Received results #{results}")
                @results_queue.push(results)
              end
            end
          end

          # socket.on(:connect) do
          #   Rails.logger.debug('Connection to LIMS results socket established...')
          #   @socket_disconnected = false
          # end

          # socket.on(:disconnect) do
          #   Rails.logger.debug('Connection to LIMS results socket lost...')
          #   @socket_disconnected = true
          # end
        end

        def fetch_results
          results = @results_queue.shift
          return results if results

          raise 'LIMS socket disconnected' if @socket_disconnected

          nil
        end

        def find_order(lims_id)
          mapping = Lab::LimsOrderMapping.where(lims_id: lims_id).select(:order_id)
          Lab::LabOrder.find_by(order_id: mapping)
        end

        def make_order_dto(order, results)
          Lab::Lims::OrderSerializer
            .serialize_order(order)
            .merge(
              id: order.accession_number,
              test_results: {
                result['test_name'] => {
                  results: results['results'].each_with_object({}) do |measure, formatted_measures|
                    measure_name, measure_value = measure

                    formatted_measures[measure_name] = { result_value: measure_value }
                  end
                },
                result_date: results['date_updated'],
                result_entered_by: {
                  first_name: results['who_updated']['first_name'],
                  last_name: results['who_updated']['last_name'],
                  id: results['who_updated']['id_number']
                }
              }
            )
        end
      end
    end
  end
end
