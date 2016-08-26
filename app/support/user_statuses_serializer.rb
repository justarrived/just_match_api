# frozen_string_literal: true

class UserStatusesSerializer
  def self.serializeble_resource
    statuses_data = User::STATUSES.map do |status_name, _status_id|
      attributes = {}
      I18n.available_locales.each do |locale|
        name = I18n.t("user.statuses.#{status_name}", locale: locale)
        description = I18n.t("user.statuses.#{status_name}_description", locale: locale)

        attributes[:"#{locale}_name"] = name
        attributes[:"#{locale}_description"] = description
      end
      JsonApiData.new(id: status_name, type: :'user-statuses', attributes: attributes)
    end
    JsonApiDatum.new(statuses_data)
  end
end
