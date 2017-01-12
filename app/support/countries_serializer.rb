# frozen_string_literal: true
class CountriesSerializer
  def self.serializeble_resource(key_transform:, filter: {})
    countries_data = []
    ISO3166::Country.translations.each do |country_code, name|
      if filter[:name]
        next unless name.downcase.starts_with?(filter[:name].downcase)
      end
      if filter[:country_code]
        next unless country_code == filter[:country_code].upcase
      end
      country = ISO3166::Country[country_code]
      attributes = {
        country_code: country_code,
        local_name: country.local_name
      }
      I18n.available_locales.each do |locale|
        # There is no translations for fa_AF, so fallback on fa
        load_locale = (locale == :fa_AF ? :fa : locale).to_s

        attributes[:"#{locale}_name"] = country.translations[load_locale]
      end
      countries_data << JsonApiData.new(
        id: country_code,
        type: :countries,
        attributes: attributes,
        key_transform: key_transform
      )
    end

    JsonApiDatum.new(countries_data)
  end
end
