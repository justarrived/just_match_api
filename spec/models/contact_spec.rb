# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Contact, type: :model do
  it 'validates presence of name, email and body' do
    contact = Contact.new.tap(&:validate)

    expect(contact.errors[:name]).not_to be_empty
    expect(contact.errors[:email]).not_to be_empty
    expect(contact.errors[:body]).not_to be_empty
  end
end

# == Schema Information
#
# Table name: contacts
#
#  id         :integer          not null, primary key
#  name       :string
#  email      :string
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
