# frozen_string_literal: true
class AddMissingBlazerDbKeys < ActiveRecord::Migration
  def change
    add_foreign_key 'blazer_dashboard_queries', 'blazer_dashboards', column: 'dashboard_id', name: 'blazer_dashboard_queries_dashboard_id_fk' # rubocop:disable Metrics/LineLength
  end
end
