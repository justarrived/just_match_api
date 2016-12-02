# frozen_string_literal: true
module FrilansFinansApi
  module Statuses
    module Invoice
      STATUSES = {
        1  => 'Not paid',
        2  => 'Paid',
        3  => 'Credit invoice',
        4  => 'Credited',
        5  => 'Client loss',
        6  => 'Partly paid',
        7  => 'Saved',
        9  => 'Credit errand',
        10 => 'Dummy invoice',
        11 => 'ROT/RUT invoice',
        12 => 'ROT/RUT',
        13 => 'Skatteverket (Swedish Tax Agency)'
      }.freeze

      PAYMENT_STATUS = {
        1 => 'Not paid',
        2 => 'Paid',
        3 => 'Partly paid',
        4 => 'Started'
      }.freeze

      APPROVAL_STATUS = {
        1 => 'Waiting on approval',
        2 => 'Approved',
        3 => 'Not approved',
        4 => 'Waiting on payment',
        5 => 'Saved'
      }.freeze

      def self.status(status_int, with_id: false)
        name = STATUSES[status_int]
        return name if name.nil?

        return name + " ##{status_int}" if with_id
        name
      end

      def self.payment_status(status_int, with_id: false)
        name = PAYMENT_STATUS[status_int]
        return name if name.nil?

        return name + " ##{status_int}" if with_id
        name
      end

      def self.approval_status(status_int, with_id: false)
        name = APPROVAL_STATUS[status_int]
        return name if name.nil?

        return name + " ##{status_int}" if with_id
        name
      end
    end
  end
end
