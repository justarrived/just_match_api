# frozen_string_literal: true

class AddMissingBlazerKeys < ActiveRecord::Migration
  def change
    # rubocop:disable Metrics/LineLength
    add_foreign_key 'blazer_audits', 'blazer_queries', column: 'query_id', name: 'blazer_audits_query_id_fk'
    add_foreign_key 'blazer_checks', 'blazer_queries', column: 'query_id', name: 'blazer_checks_query_id_fk'
    add_foreign_key 'blazer_dashboard_queries', 'blazer_queries', column: 'query_id', name: 'blazer_dashboard_queries_query_id_fk'
    add_foreign_key 'blazer_queries', 'users', column: 'creator_id', name: 'blazer_queries_creator_id_fk'
    # rubocop:enable Metrics/LineLength
  end
end
