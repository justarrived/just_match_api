# frozen_string_literal: true
class FrilansFinansImporter
  def self.professions(client: FrilansFinansApi::Client.new)
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
end
