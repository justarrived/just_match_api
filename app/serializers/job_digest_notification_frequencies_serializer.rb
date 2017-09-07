# frozen_string_literal: true

class JobDigestNotificationFrequenciesSerializer
  def self.serializable_resource
    locale = I18n.locale
    language_id = Language.find_by_locale(locale)&.id

    frequencies = JobDigest::NOTIFICATION_FREQUENCY.map do |key, _id|
      name = I18n.t("job_digest.notification_frequencies.#{key}.name")
      description = I18n.t("job_digest.notification_frequencies.#{key}.description")
      attributes = {
        key: key,
        name: name,
        description: description,
        language_id: language_id
      }

      attributes[:translated_text] = {
        name: name,
        description: description,
        language_id: language_id
      }

      relationships = JsonApiRelationships.new
      relationships.add(relation: 'language', type: 'languages', id: language_id)

      JsonApiData.new(
        id: key,
        type: :job_digest_notification_frequencies,
        attributes: attributes,
        relationships: relationships
      )
    end
    JsonApiDatum.new(frequencies)
  end
end
