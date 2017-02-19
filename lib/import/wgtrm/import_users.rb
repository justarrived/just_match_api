# frozen_string_literal: true
require 'import/wgtrm/user'
require 'import/wgtrm/import_user'

module Wgtrm
  class ImportUsers
    attr_reader :users, :user_languages, :user_interests, :user_tags, :imports

    def self.commit(rows, ignore_emails: [])
      new(rows, ignore_emails: ignore_emails).tap(&:commit)
    end

    def initialize(rows, ignore_emails: [])
      @rows = rows
      @imports = nil
      @ignore_emails = ignore_emails

      @users = []
      @user_languages = []
      @user_interests = []
      @user_tags = []
    end

    def commit
      @imports ||= @rows.map do |row|
        wgtrm_user = Wgtrm::User.new(row)
        email = EmailAddress.normalize(wgtrm_user.email)
        next if @ignore_emails.include?(email)
        phone = wgtrm_user.phone

        # will return nil if there is an existing user already
        user = find_or_initialize_user(email, phone) || next
        import = ImportUser.commit(user, wgtrm_user)

        @users << user
        @user_languages += import.user_languages
        @user_interests += import.user_tags
        @user_tags += import.user_interests
        import
      end.compact
    end

    def find_or_initialize_user(email, phone)
      user = ::User.find_by(email: email)
      user_by_phone = ::User.find_by(phone: phone)

      user = user_by_phone if user.nil? && user_by_phone

      user ||= ::User.new.tap do |u|
        u.email = email
        u.password = SecureRandom.uuid
      end

      if !phone.blank? && PhoneNumber.swedish_number?(phone) && PhoneNumber.valid?(phone)
        user.phone ||= phone
      end
      user
    end
  end
end
