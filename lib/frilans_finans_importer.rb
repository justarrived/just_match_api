# frozen_string_literal: true
require 'frilans_finans_api/frilans_finans_api'

class FrilansFinansImporter
  def self.perform
    professions
  end

  def self.professions
    current_page = 1
    total_pages = 2

    while total_pages >= current_page
      professions_index = FrilansFinansApi::Profession.index(page: current_page)
      total_pages = professions_index.total_pages

      professions_index.resources.each do |profession|
        Category.find_or_create_by!(name: profession[:title])
      end

      current_page += 1
    end
  end
end
