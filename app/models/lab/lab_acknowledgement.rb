# frozen_string_literal: true

module Lab
  class LabAcknowledgement < ::LimsAcknowledgementStatus
    enum acknowledgment_type: %i[test_results_delivered_to_site_electronically test_results_delivered_to_site_manually]
  end
end
