# frozen_string_literal: true
module Import
  class UsersFromSheet
    # TODO: Fix before commit
    #   - What is the `filter` column? translatable to tags?
    #
    SHEET_FIELDS_MAP = [
      :timestamp,
      :name,
      :email,
      :current_status,
      :dokument,
      :arbetsformedlingen_registered_at,
      :interview_comment,
      :user_id,
      :interview_date,
      :interviewed_by,

      :filter,
      :availability,

      :swedish,
      :english,
      :arabic,
      :tigrinya,
      :dari,
      :pashto,
      :french,
      :german,
      :spanish,

      :swedish_driving_license,
      :social_skills,
      :flexibility,
      :ambition,
      :attitude,
      :independent,
      :economy,
      :translation,
      :it
    ].freeze

    def self.call
      csv_string = File.read('tmp/validation-mapping.csv')
      csv = HoneyFormat::CSV.new(csv_string)

      csv.rows.each do |user|
        process_user(user)
      end
    end

    def self.process_user(data)
      process_foi(user)
    end

    def self.proccess_user_attributes(user, data)

    end

    def self.process_foi(user, data)
      [
        :foi_general_maintenance,
        :foi_construction,
        :foi_administration,
        :foi_cleaning,
        :foi_restaurant_or_kitchen,
        :foi_customer_service
      ]
    end
  end
end
