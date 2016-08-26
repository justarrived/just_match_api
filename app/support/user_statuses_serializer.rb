# frozen_string_literal: true

class UserStatusesSerializer
  def self.serializeble_resource
    statuses_data = User::STATUSES.map do |status_name, status_id|
      attributes = {
        name: I18n.t("user.statuses.#{status_name}"),
        description: I18n.t("user.statuses.#{status_name}_description")
      }
      JsonApiData.new(id: status_id, type: :'user-statuses', attributes: attributes)
    end
    JsonApiDatum.new(statuses_data)
  end
end
