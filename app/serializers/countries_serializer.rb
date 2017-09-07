# frozen_string_literal: true

class CountriesSerializer
  def self.serializable_resource(filter: {})
    countries_data = []
    language_id = Language.find_by(lang_code: I18n.locale)&.id

    ISO3166::Country.translations.each do |country_code, name|
      if filter[:country_code]
        next unless country_code == filter[:country_code].upcase
      end
      country = ISO3166::Country[country_code]
      local_name = country.local_name
      translated_name = country.translations[locale.to_s]
      attributes = {
        country_code: country_code,
        name: translated_name,
        local_name: local_name,
        language_id: language_id
      }

      if name_filter = filter[:name]
        with_en_name = eql_name?(name, name_filter)
        with_local_name = eql_name?(local_name, name_filter)
        with_locale_name = eql_name?(translated_name, name_filter)

        next unless with_en_name || with_local_name || with_locale_name
      end

      attributes[:name] = translated_name
      attributes[:translated_text] = {
        name: translated_name,
        language_id: language_id
      }

      relationships = JsonApiRelationships.new
      relationships.add(relation: 'language', type: 'languages', id: language_id)

      countries_data << JsonApiData.new(
        id: country_code,
        type: :countries,
        attributes: attributes,
        relationships: relationships
      )
    end

    JsonApiDatum.new(countries_data)
  end

  def self.locale
    locale = I18n.locale
    # There is no translations for fa_AF, so fallback on fa
    locale = :fa if locale == :fa_AF
    locale
  end

  def self.eql_name?(name, name_filter)
    return false if name.nil?
    return false if name_filter.nil?

    name.downcase.starts_with?(name_filter.downcase)
  end
end
