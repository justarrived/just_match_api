# frozen_string_literal: true
class FrilansFinansImporter
  def self.professions(client: FrilansFinansApi.client_klass.new)
    FrilansFinansApi::Profession.walk(client: client) do |document|
      document.resources.each do |profession|
        id = profession.id
        attributes = { name: profession.attributes['title'] }

        category = Category.find_or_initialize_by(frilans_finans_id: id)
        category.assign_attributes(attributes)
        category.save!
      end
    end
  end

  def self.currencies(client: FrilansFinansApi.client_klass.new)
    FrilansFinansApi::Currency.walk(client: client) do |document|
      document.resources.each do |currency|
        record = Currency.find_or_initialize_by(frilans_finans_id: currency.id)
        record.currency_code = currency.attributes['currency_code']
        record.save!
      end
    end
  end
end
