# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/contact_mailer
class ApplicationMailerPreview < ActionMailer::Preview
  def product_information_email
    ApplicationMailer.product_information_email(
      user: User.first,
      subject: 'Product update!',
      body: 'Yay! We have new features.'
    )
  end
end
