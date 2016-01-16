# == Schema Information
#
# Table name: languages
#
#  id         :integer          not null, primary key
#  lang_code  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe 'Languages', type: :request do
  describe 'GET /languages' do
    it 'works!' do
      get api_v1_languages_path(id: 1)
      expect(response).to have_http_status(200)
    end
  end
end
