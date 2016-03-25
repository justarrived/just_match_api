# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET /users' do
    it 'returns 401 by default' do
      get api_v1_users_path
      expect(response).to have_http_status(401)
    end
  end
end

# == Schema Information
#
# Table name: users
#
#  id                        :integer          not null, primary key
#  email                     :string
#  phone                     :string
#  description               :text
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  latitude                  :float
#  longitude                 :float
#  language_id               :integer
#  anonymized                :boolean          default(FALSE)
#  auth_token                :string
#  password_hash             :string
#  password_salt             :string
#  admin                     :boolean          default(FALSE)
#  street                    :string
#  zip                       :string
#  zip_latitude              :float
#  zip_longitude             :float
#  first_name                :string
#  last_name                 :string
#  ssn                       :string
#  company_id                :integer
#  banned                    :boolean          default(FALSE)
#  job_experience            :text
#  education                 :text
#  one_time_token            :string
#  one_time_token_expires_at :datetime
#
# Indexes
#
#  index_users_on_auth_token      (auth_token) UNIQUE
#  index_users_on_company_id      (company_id)
#  index_users_on_email           (email) UNIQUE
#  index_users_on_language_id     (language_id)
#  index_users_on_one_time_token  (one_time_token) UNIQUE
#  index_users_on_ssn             (ssn) UNIQUE
#
# Foreign Keys
#
#  fk_rails_45f4f12508  (language_id => languages.id)
#  fk_rails_7682a3bdfe  (company_id => companies.id)
#
