# frozen_string_literal: true

module Lab
  class OrdersController < ApplicationController
    skip_before_action :authenticate, only: %i[order_status order_result summary]
    before_action :authenticate_request, only: %i[order_status order_result summary]

    def create
      order_params_list = params.require(:orders)
      orders = order_params_list.map do |order_params|
        OrdersService.order_test(order_params)
      end

      orders.each { |order| Lab::PushOrderJob.perform_later(order.fetch(:order_id)) }

      render json: orders, status: :created
    end

    def update
      specimen = params.require(:specimen).slice(:concept_id)
      order = OrdersService.update_order(params[:id], specimen:, force_update: params[:force_update])
      Lab::PushOrderJob.perform_later(order.fetch(:order_id))

      render json: order
    end

    def index
      filters = params.slice(:patient_id, :accession_number, :date, :status)

      Lab::UpdatePatientOrdersJob.perform_later(filters[:patient_id]) if filters[:patient_id]
      render json: OrdersSearchService.find_orders(filters)
    end

    def verify_tracking_number
      tracking_number = params.require(:accession_number)
      render json: { exists: OrdersService.check_tracking_number(tracking_number) }, status: :ok
    end

    def destroy
      OrdersService.void_order(params[:id], params[:reason])
      Lab::VoidOrderJob.perform_later(params[:id])

      render status: :no_content
    end

    def order_status
      order_params = params.permit(:tracking_number, :status, :status_time, :comments)
      OrdersService.update_order_status(order_params)
      render json: { message: "Status for order #{order_params['tracking_number']} successfully updated" }, status: :ok
    end

    def order_result
      params.permit!
      order_params = params[:data].to_h
      OrdersService.update_order_result(order_params)
      render json: { message: 'Results processed successfully' }, status: :ok
    end

    def summary
      start_date = params[:start_date].present? ? params[:start_date] : 24.hours.ago.beginning_of_day
      end_date = params[:end_date].present? ? params[:end_date].to_date.end_of_day : 24.hours.ago.end_of_day
      concept_id = params[:concept_id]
      include_data = params[:include_data]
      orders = OrdersService.lab_orders(start_date, end_date, concept_id, include_data: include_data)
      render json: orders, status: :ok
    end

    private

    def authenticate_request
      header = request.headers['Authorization']
      content = header.split(' ')
      auth_scheme = content.first
      unless header
        errors = ['Authorization token required']
        render json: { errors: errors }, status: :unauthorized
        return false
      end
      unless auth_scheme == 'Bearer'
        errors = ['Authorization token bearer scheme required']
        render json: { errors: errors }, status: :unauthorized
        return false
      end
  
      process_token(content.last)
    end

    def process_token(token)
      browser = Browser.new(request.user_agent)
      decoded = Lab::JsonWebTokenService.decode(token, request.remote_ip + browser.name + browser.version)
      user(decoded)
    end

    def user(decoded)
      User.current = User.find decoded[:user_id]
    end
  end
end
