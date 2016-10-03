# frozen_string_literal: true
class Analytics
  cattr_accessor :backend
  self.backend = Segment::Analytics

  def initialize(user, client: nil)
    @user = user
    @client = client || begin
      backend.new(write_key: ENV.fetch('SEGMENT_ANALYTICS_KEY'))
    end
  end

  def track_user_creation
    identify
    track(
      user_id: user.id,
      event: 'Create User',
      properties: {
        zip: user.zip
      }
    )
  end

  def track_user_sign_in
    identify
    track(user_id: user.id, event: 'Sign In User')
  end

  private

  attr_reader :user, :client

  def identify
    client.identify(identify_params)
  end

  def identify_params
    {
      user_id: user.id,
      traits: user_traits
    }
  end

  def user_traits
    {
      email: user.email,
      phone: user.phone,
      first_name: user.first_name,
      last_name: user.last_name,
      zip: user.zip
    }.reject { |_key, value| value.blank? }
  end

  def track(options)
    client.track(options)
  end
end
