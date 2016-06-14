# frozen_string_literal: true
class ApplicationTexter
  cattr_accessor :default_from
  cattr_accessor :delayed_job_klass

  self.delayed_job_klass = TexterJob
  self.default_from = ENV.fetch('TWILIO_NUMBER') do
    Rails.logger.warn "WARN -- : #{self} is missing env variable TWILIO_NUMBER"
    nil
  end

  def self.text(from: default_from, to:, template:)
    body = ApplicationController.render(template, assigns: _pack_instance_variables)
    new(from: from, to: to, body: body)
  end

  def self._pack_instance_variables
    assigns = {}
    instance_variables.each do |instance_variable|
      variable_name = instance_variable.to_s[1..-1] # Remove '@' char
      assigns[variable_name] = instance_variable_get(instance_variable)
    end
    assigns
  end

  def initialize(from: default_from, to:, body:)
    @from = from
    @to = to
    @body = body
  end

  def deliver_later
    delayed_job_klass.perform_later(from: @from, to: @to, body: @body)
  end

  def deliver_now
    client = SMSClient.new
    client.send_message(from: @from, to: @to, body: @body)
  end
end
