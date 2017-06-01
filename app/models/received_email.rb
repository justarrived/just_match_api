# frozen_string_literal: true

class ReceivedEmail < ApplicationRecord
end

# == Schema Information
#
# Table name: received_emails
#
#  id           :integer          not null, primary key
#  from_address :string
#  to_address   :string
#  subject      :string
#  text_body    :text
#  html_body    :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
