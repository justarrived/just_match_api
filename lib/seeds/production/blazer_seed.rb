# frozen_string_literal: true
class BlazerSeed
  BLAZER_MODELS = [User, Rating, Chat, Message, Job, Comment, JobUser].freeze

  def self.call
    new.call
  end

  def call
    BLAZER_MODELS.each do |model_klass|
      dashboard = create_dashboard(model_klass)
      dashboard.queries = [
        create_cumulative_query(model_klass),
        create_per_week_query(model_klass),
        create_time_range_sql(model_klass, column: :created_at)
      ]
      create_time_range_sql(model_klass, column: :updated_at)
    end
  end

  def create_dashboard(model_klass)
    Blazer::Dashboard.create!(name: pretty_table_name(model_klass))
  end

  def create_per_week_query(model_klass)
    pretty_table_name = pretty_table_name(model_klass)
    Blazer::Query.create!(
      name: "New #{pretty_table_name} Per Week",
      description: '',
      statement: per_week_sql(model_klass),
      data_source: 'main'
    )
  end

  def create_cumulative_query(model_klass)
    pretty_table_name = pretty_table_name(model_klass)
    Blazer::Query.create!(
      name: "Cumulative #{pretty_table_name}",
      description: "Cumulative #{pretty_table_name} grouped on week.",
      statement: cumulative_sql(model_klass),
      data_source: 'main'
    )
  end

  def create_time_range_sql(model_klass, column:)
    pretty_table_name = pretty_table_name(model_klass)
    pretty_column_name = column.to_s.humanize.titleize
    Blazer::Query.create!(
      name: "#{pretty_table_name} By #{pretty_column_name} Time Range",
      description: "Filter #{pretty_table_name} by #{pretty_column_name} Time Range",
      statement: time_range_sql(model_klass, column: column),
      data_source: 'main'
    )
  end

  def time_range_sql(model_klass, column:)
    table_name = table_name(model_klass)
    "SELECT * FROM #{table_name}
    WHERE #{column} >= {start_time} AND #{column} <= {end_time}"
  end

  def per_week_sql(model_klass)
    table_name = table_name(model_klass)
    "SELECT
      date_trunc('week', created_at)::date AS week, COUNT(*) AS new_#{table_name}
    FROM #{table_name} GROUP BY week ORDER BY week"
  end

  def cumulative_sql(model_klass)
    table_name = table_name(model_klass)
    "SELECT
      date_trunc('week', created_at)::date AS week,
      sum(
        count(id)) OVER (ORDER BY date_trunc('week', created_at)::date
      ) AS #{table_name}_count
    FROM #{table_name}
    GROUP BY week"
  end

  def table_name(model_klass)
    model_klass.model_name.plural
  end

  def pretty_table_name(model_klass)
    table_name(model_klass).humanize.titleize
  end
end
