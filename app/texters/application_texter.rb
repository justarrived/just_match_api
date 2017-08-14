# frozen_string_literal: true

class ApplicationTexter
  cattr_accessor :default_from
  cattr_accessor :delayed_job_klass

  self.delayed_job_klass = TexterJob
  self.default_from = AppSecrets.twilio_number

  def self.text(from: default_from, to:, template:, client: SMSClient.new)
    body = ApplicationController.render(template, assigns: _pack_instance_variables)
    new(from: from, to: to, body: body, client: client)
  end

  def self._pack_instance_variables
    assigns = {}
    instance_variables.each do |instance_variable|
      # Rails is being Rails, so sometimes there is an instance variable @parent_name
      # defined (and of course... sometimes not [sic])
      # http://api.rubyonrails.org/classes/Module.html#method-i-parent_name
      next if instance_variable == :@parent_name
      # Instance variables prefix with __ are considered private
      next if instance_variable.to_s.start_with?('@__')

      variable_name = instance_variable.to_s[1..-1] # Remove '@' char
      assigns[variable_name] = instance_variable_get(instance_variable)
    end
    assigns
  end

  def initialize(from: default_from, to:, body:, client: SMSClient.new)
    @from = from
    @to = to
    @body = body
    @__client = client
  end

  def deliver_later
    delayed_job_klass.perform_later(from: @from, to: @to, body: @body)
  end

  def deliver_now
    client.send_message(from: @from, to: @to, body: @body)
  end

  private

  def client
    @__client
  end
end
