# frozen_string_literal: true
module Wgtrm
  class User
    LanguageProficiency = Struct.new(:name, :proficiency)

    PROFICIENCY_MAP = {
      'Able to communicate' => 2,
      'Basic knowledge' => 3,
      'Able to negotiate' => 4,
      'Native speaker' => 5
    }.freeze

    LANGUAGE_NAME_MAP = {
      'Tigrigna' => 'Tigrinya',
      'Somali' => 'Somalia',
      'Slovene' => 'Slovenian',
      'Persian' => 'Farsi',
      'PashtuDari' => 'Dari',
      'Pashtu' => 'Pashto',
      'Chinese,' => 'Chinese',
      'Mandarin' => 'Chinese',
      'Indonesia' => 'Indonesian'
    }.freeze

    attr_reader :row

    def initialize(row_struct)
      @row = row_struct
    end

    delegate :name, to: :row
    delegate :email, to: :row
    delegate :residence, to: :row
    delegate :country_of_origin, to: :row
    delegate :level_of_study, to: :row
    delegate :study_major, to: :row
    delegate :latest_university, to: :row
    delegate :field_of_study, to: :row
    delegate :graduation_date, to: :row

    def phone
      row.mobile_phone
    end

    def languages
      split_column(row.languages).map do |string|
        # string = English (Able to negotiate)
        parts = string.split('(')
        language = parts.first.strip # 'English'
        level = parts.last[0..-2]    # 'Able to negotiate'

        name = LANGUAGE_NAME_MAP.fetch(language, language)
        proficiency = PROFICIENCY_MAP.fetch(level)

        LanguageProficiency.new(name, proficiency)
      end
    end

    def tags
      split_column(row.tags)
    end

    def interests
      split_column(row.functions)
    end

    private

    def split_column(column)
      return [] if column.nil? || column.empty?

      column.split('/').map(&:strip)
    end
  end
end
