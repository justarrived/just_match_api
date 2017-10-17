# frozen_string_literal: true

class CompanyMailer < ApplicationMailer
  def new_companies_digest_email(email:, companies:)
    total = companies.length
    subject = if total > 1
                "#{total} new companies created"
              else
                "New company: #{companies.first.name})"
              end

    @companies = companies

    mail(to: email, subject: subject)
  end
end
