# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/admin_mailer
class CompanyMailerPreview < ActionMailer::Preview
  def new_companies_digest_email
    CompanyMailer.new_companies_digest_email(
      email: 'finance@example.com',
      companies: Company.last(4)
    )
  end
end
