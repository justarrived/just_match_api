# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Ahoy::EventsController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      path = '/api/v1/ahoy/events'
      route_path = 'api/v1/ahoy/events#create'
      expect(post: path).to route_to(route_path)
    end
  end
end

# == Schema Information
#
# Table name: ahoy_events
#
#  id         :integer          not null, primary key
#  visit_id   :integer
#  user_id    :integer
#  name       :string
#  properties :jsonb
#  time       :datetime
#
# Indexes
#
#  index_ahoy_events_on_name_and_time      (name,time)
#  index_ahoy_events_on_user_id_and_name   (user_id,name)
#  index_ahoy_events_on_visit_id_and_name  (visit_id,name)
#
# Foreign Keys
#
#  ahoy_events_user_id_fk   (user_id => users.id)
#  ahoy_events_visit_id_fk  (visit_id => visits.id)
#
